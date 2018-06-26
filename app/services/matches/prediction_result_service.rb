module Matches
  class PredictionResultService
    def initialize(group, match)
      @group = group
      @match = match
    end

    def results
      results = result(@match)
      add_match_share(results)
    end

    private

    def result(match)
      @group.users.pluck(:id).each_with_object([]) do |user_id, results|
        user_result = { user_id: user_id, match_result: false, score: false, decider: false }
        prediction = match_predictions.find { |p| (p.match_id == match.id) && (p.user_id == user_id) }
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
      if prediction.team_1_goals == match.team_1_goals && prediction.team_2_goals == match.team_2_goals
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

    def add_match_share(results)
      @standings_table_service = Groups::StandingsTableService.new(@group)
      results.each_with_object([]) do |user_result, results_with_share|
        user_result[:match_share] = @standings_table_service.match_share(@match, user_result[:user_id])
        results_with_share << user_result
      end
    end

    def match_predictions
      @match_predictions ||= Prediction.where(user: @group.users, match: @match).includes(:match).to_a
    end
  end
end
