class PredictionsController < ApplicationController
  def create
    prediction = current_user.predictions.new(prediction_params)
    head :ok if prediction.save!
  end

  def update
    prediction = Prediction.find_by(match_id: prediction_params[:match_id])
    head :ok if prediction.update!(winner_id: prediction_params[:winner_id])
  end

  private

  def prediction_params
    @prediction_params ||= params.require(:prediction).permit(:match_id, :winner_id)
  end
end