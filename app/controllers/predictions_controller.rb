class PredictionsController < ApplicationController
  def create
    prediction = current_user.predictions.new(prediction_params)
    match = Match.find(prediction_params[:match_id])
    return head(:bad_request) if match.locked?
    prediction.decider = prediction_params[:decider] if match.knock_out?
    prediction.save!
    head :ok
  end

  def update
    prediction = current_user.predictions.find_by(match_id: prediction_params[:match_id])
    match = Match.find(prediction_params[:match_id])
    return head(:bad_request) if match.locked?
    prediction.update!(team_1_goals: prediction_params[:team_1_goals], team_2_goals: prediction_params[:team_2_goals])
    prediction.update!(decider: prediction_params[:decider]) if match.knock_out?
    head :ok
  end

  private

  def prediction_params
    @prediction_params ||= params.require(:prediction).permit(:match_id, :team_1_goals, :team_2_goals, :decider)
  end
end