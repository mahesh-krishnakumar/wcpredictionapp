class PredictionsController < ApplicationController
  def create
    prediction = current_user.predictions.new(prediction_params)
    match = Match.find(prediction_params[:match_id])
    return head(:bad_request) if match.locked?
    prediction.decider = prediction_params[:decider] if match.knock_out?
    prediction.save!
    render status: :ok, json: {
      prediction: prediction_response(prediction),
      matches_predicted: predicted_match_ids
    }
  end

  def update
    prediction = current_user.predictions.find_by(match_id: prediction_params[:match_id])
    match = Match.find(prediction_params[:match_id])
    return head(:bad_request) if match.locked?
    prediction.update!(prediction_params)
    render status: :ok, json: {
      prediction: prediction_response(prediction),
      matches_predicted: predicted_match_ids
    }
  end

  private

  def prediction_params
    @prediction_params ||= params.require(:prediction).permit(:match_id, :team_1_goals, :team_2_goals, :decider, :winner_id)
  end

  def prediction_response(prediction)
    {
      id: prediction.id,
      summary: prediction.summary_text
    }
  end

  def predicted_match_ids
    current_user.predictions.pluck(:match_id)
  end
end