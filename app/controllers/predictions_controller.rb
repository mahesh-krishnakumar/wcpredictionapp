class PredictionsController < ApplicationController
  def create
    prediction = current_user.predictions.new(prediction_params)
    head :ok if prediction.save!
  end

  private

  def prediction_params
    params.require(:prediction).permit(:match_id, :winner_id)
  end
end