module Groups
  class StandingsTableService
    def initialize(group = nil)
      @group = group
      @users = group.present? ? group.users : User.all
      @users_count = @users.count
      @all_predictions = group.present? ? group.predictions : Prediction.all
    end

    def table
      # Initialize an empty result
      result = @users.each_with_object({}) do |user, resultx|
        resultx[user.id] = 0
      end

      # Populate points
      Match.completed.each do |match|
        # skip if nobody is even got the winners right
        next unless pot_share(match, :winner).present?

        # Add the winner pot share
        result = add_to_pot(result, match, :winner)
        # Add the score pot share,
        result = add_to_pot(result, match, :score)
        # Add the decider pot share, except for group stage
        result = add_to_pot(result, match, :decider) if match.knock_out?
      end

      # round all points to one decimal
      result = result.map { |user_id, points| [user_id, points.round(1)] }

      # sort by points
      result.sort_by! { |e| -(e.second) }

      # add ranks
      sorted_points = result.map(&:second).sort.uniq.reverse
      result.each { |e| e << sorted_points.index(e[1]) + 1 }
    end

    def match_share(match, user_id)
      share = 0
      share += pot_share(match, :winner)[user_id] if pot_share(match, :winner).present?
      share += pot_share(match, :score)[user_id] if pot_share(match, :score).present?
      share += pot_share(match, :decider)[user_id] if match.knock_out? && pot_share(match, :decider).present?

      share
    end

    def standing(user)
      entry = table.find { |entry| entry.first == user.id }
      { rank: entry[2], points: entry[1] }
    end

    private

    def add_to_pot(current_pot, match, metric)
      pot_share = pot_share(match, metric)

      # Return the pot as is if no one got this metric right.
      return current_pot unless pot_share.present?

      # else update the pot accordingly
      new_pot = current_pot
      pot_share.each do |user_id, share|
        new_pot[user_id] += share
      end

      new_pot
    end

    def pot_share(match, metric)
      return if correct_predictors(match, metric).empty?

      total_pot = @users_count * pot_split[match.stage][metric]
      winners_share = total_pot.to_f / correct_predictors(match, metric).count
      @users.pluck(:id).each_with_object({}) do |user_id, result|
        result[user_id] = -pot_split[match.stage][metric]
        result[user_id] += winners_share if user_id.in?(correct_predictors(match, metric))
      end
    end

    def predictions(match)
      @predictions ||= Hash.new do |hash, key|
        hash[key] = @all_predictions.where(match: key)
      end

      @predictions[match]
    end

    def correct_predictors(match, metric)
      @correct_predictors ||= Hash.new do |hash, key|
        matchx = key[0]; metricx = key[1]
        true_winner = matchx.winner
        correct_winner_predictors = predictions(matchx).select { |p| p.winner == true_winner }.pluck(:user_id)
        hash[key] = if metricx == :winner
          correct_winner_predictors
        else
          true_result = matchx.send(metric_method[metricx])
          if metricx == :score && matchx.decider == Match::DECIDER_TYPE_PENALTY
            predictions(matchx).where(user: correct_winner_predictors).where(decider: Match::DECIDER_TYPE_PENALTY).pluck(:user_id)
          else
            predictions(matchx).where(user: correct_winner_predictors)
              .select { |p| p.send(metric_method[metricx]) == true_result }.pluck(:user_id)
          end
        end
      end

      @correct_predictors[[match, metric]]
    end

    def pot_split
      {
        group: { winner: 20, score: 10 },
        pre_quarter: { winner: 10, score: 10, decider: 10 },
        quarter: { winner: 10, score: 10, decider: 10 },
        semi_final: { winner: 30, score: 10, decider: 10 },
        final: { winner: 70, score: 10, decider: 20 }
      }.with_indifferent_access
    end

    def metric_method
      {
        winner: :winner,
        score: :score_as_string,
        decider: :decider
      }
    end
  end
end