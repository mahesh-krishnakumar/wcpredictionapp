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
        next unless winner_pot_share(match).present?

        # Add the winner pot share
        winner_pot_share(match).each do |user_id, share|
          result[user_id] += share
        end

        # Add the score pot share, except if it was penalties
        if match.decider != Match::DECIDER_TYPE_PENALTY && score_pot_share(match).present?
          score_pot_share(match).each do |user_id, share|
            result[user_id] += share
          end
        end

        # Add the decider pot share, except for group stage
        if match.knock_out? && decider_pot_share(match).present?
          decider_pot_share(match).each do |user_id, share|
            result[user_id] += share
          end
        end
      end

      result
    end

    private

    def winner_pot_share(match)
      return if correct_winner_predictors(match).empty?
      
      total_winner_pot = predictions_count(match) * pot_split[match.stage][:winner]
      correct_winner_share = total_winner_pot / correct_winner_predictors(match).count
      correct_winner_predictors(match).each_with_object({}) do |user, result|
        result[user] = correct_winner_share
      end
    end

    def score_pot_share(match)
      return if correct_score_predictors(match).empty?

      total_score_pot = predictions_count(match) * pot_split[match.stage][:score]
      correct_score_share = total_score_pot / correct_score_predictors(match).count
      correct_score_predictors(match).each_with_object({}) do |user, result|
        result[user] = correct_score_share
      end
    end

    def decider_pot_share(match)
      return if correct_decider_predictors(match).empty?

      total_decider_pot = predictions_count(match) * pot_split[match.stage][:decider]
      correct_decider_share = total_decider_pot / correct_decider_predictors(match).count
      correct_decider_predictors(match).each_with_object({}) do |user, result|
        result[user] = correct_decider_share
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

    def correct_winner_predictors(match)
      @correct_winner_predictors ||= Hash.new do |hash, key|
        true_winner = key.winner
        hash[key] = predictions(key).select{ |p| p.winner == true_winner }.pluck(:user_id)
      end

      @correct_winner_predictors[match]
    end
    
    def correct_score_predictors(match)
      @correct_score_predictors ||= Hash.new do |hash, key|
        true_score_as_string = key.score_as_string
        hash[key] = predictions(key).select{ |p| p.score_as_string == true_score_as_string }.pluck(:user_id)
      end

      @correct_score_predictors[match]
    end

    def correct_decider_predictors(match)
      @correct_decider_predictors ||= Hash.new do |hash,key|
        true_decider = key.decider
        hash[key] = predictions(key).select{ |p| p.decider == true_decider }.pluck(:user_id)
      end

      @correct_decider_predictors[match]
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
  end
end