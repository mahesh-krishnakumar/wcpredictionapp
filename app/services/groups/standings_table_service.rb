module Groups
  class StandingsTableService
    def initialize(group)
      @group = group
    end

    def table
      # Initialize an empty result
      result = @group.users.each_with_object({}) do |user, result|
        result[user.id] = 0
      end
      
      Match.completed.each do |match|
        # skip if nobody is even got the winners right
        next unless pot_share(match, :winner).present?

        # Add the winner pot share
        pot_share(match, :winner).each do |user_id, share|
          result[user_id] += share
        end

        # Add the score pot share, except if it was penalties
        if match.decider != Match::DECIDER_TYPE_PENALTY && score_pot_share(match).present?
          pot_share(match, :score).each do |user_id, share|
            result[user_id] += share
          end
        end

        # Add the decider pot share, except for group stage
        if match.knock_out? && decider_pot_share(match).present?
          pot_share(match, :decider).each do |user_id, share|
            result[user_id] += share
          end
        end
      end

      result
    end

    private

    def pot_share(match, metric)
      return if correct_predictors(match, metric).empty?

      total_pot = predictions_count(match) * pot_split[match.stage][metric]
      per_head_share = total_pot / correct_predictors(match, metric).count
      correct_predictors(match, metric).each_with_object({}) do |user, result|
        result[user] = per_head_share
      end
    end
    
    def predictions(match)
      @predictions ||= Hash.new do |hash,key|
        hash[key] = @group.predictions.where(match: key)
      end

      @predictions[match]
    end
    
    def predictions_count(match)
      @predictions_count ||= Hash.new do |hash, key|
        hash[key] = predictions(key).count
      end

      @predictions_count[match]
    end

    def correct_predictors(match, metric)
      @correct_predictors ||= Hash.new do |hash,key|
        matchx = key[0]; metricx = key[1]
        true_winner = matchx.winner
        correct_winner_predictors = predictions(matchx).select{ |p| p.winner == true_winner }.pluck(:user_id)
        hash[key] = if metricx == :winner
          correct_winner_predictors
        else
          true_result = matchx.send(metric_method[metricx])
          predictions(matchx).where(user: correct_winner_predictors)
            .select{ |p| p.send(metric_method[metricx]) == true_result }.pluck(:user_id)
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