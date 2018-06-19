module Matches
  class PredictionListService
    def initialize(group)
      @group = group
      @user_ids = @group.users.pluck(:id)
      @group_predictions = Prediction.where(user_id: @user_ids).to_a
      @locked_match_ids = Match.locked_for_prediction.pluck(:id)
    end

    def list
      @locked_match_ids.each_with_object({}) do |match_id, predictions|
        predictions[match_id] = prediction_list(match_id)
      end
    end

    private

    def prediction_list(match_id)
      @user_ids.each_with_object([]) do |user_id, predictions|
        prediction = @group_predictions.find { |p| (p.user_id == user_id) && (p.match_id == match_id) }
        predictions <<
          if prediction.blank?
            { user_id: user_id, prediction: '-' }
          else
            { user_id: user_id, prediction: prediction.summary_text }
          end
      end
    end
  end
end