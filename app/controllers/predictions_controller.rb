class PredictionsController < ApplicationController
  def create
    prediction = current_user.predictions.new(prediction_params)
    match = Match.find(prediction_params[:match_id])
    return head(:bad_request) if match.locked?
    prediction.save!
    head :ok
  end

  def update
    prediction = Prediction.find_by(match_id: prediction_params[:match_id])
    match = Match.find(prediction_params[:match_id])
    return head(:bad_request) if match.locked?
    prediction.update!(winner_id: prediction_params[:winner_id])
    head :ok
  end

  private

  def prediction_params
    @prediction_params ||= params.require(:prediction).permit(:match_id, :winner_id)
  end
end