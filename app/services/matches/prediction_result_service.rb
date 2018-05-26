module Matches
  class PredictionResultService
    def initialize(group)
      @group = group
      @completed_matches = Match.completed
    end

    def results
      @completed_matches.each_with_object({}) do |match, results|
        results[match.id] = result(match)
      end
    end

    private

    def result(match)
      @group.users.each_with_object([]) do |user, results|
        user_result = { user_id: user.id, match_result: false, score: false, decider: false }
        prediction = Prediction.where(user: user, match: match).first
        results <<
          if prediction.blank? || (match.winner != prediction.winner)
            user_result
          elsif match.knock_out?
            knock_out_result(match, prediction, user_result)
          else
            group_stage_result(match, prediction, user_result)
          end
      end
    end

    def knock_out_result(match, prediction, user_result)
      user_result[:match_result] = true
      user_result[:decider] = true if match.decider == prediction.decider

      if match.decider == Match::DECIDER_TYPE_PENALTY && prediction.decider == Match::DECIDER_TYPE_PENALTY
        user_result[:score] = true
      elsif prediction.team_1_goals == match.team_1_goals && prediction.team_2_goals == match.team_2_goals
        user_result[:score] = true
      end
      user_result
    end

    def group_stage_result(match, prediction, user_result)
      user_result[:match_result] = true
      user_result[:decider] = false

      if prediction.team_1_goals == match.team_1_goals && prediction.team_2_goals == match.team_2_goals
        user_result[:score] = true
      end
      user_result
    end
  end
end
