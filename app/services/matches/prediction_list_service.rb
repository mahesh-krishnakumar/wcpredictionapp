module Matches
  class PredictionListService
    def initialize(group)
      @group = group
      @locked_matches = Match.locked_for_prediction
    end

    def list
      @locked_matches.each_with_object({}) do |match, predictions|
        predictions[match.id] = prediction_list(match)
      end
    end

    private

    def prediction_list(match)
      @group.users.pluck(:id).each_with_object([]) do |user_id, predictions|
        prediction = Prediction.where(user_id: user_id, match: match).first
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