class PredictionsController < ApplicationController
  def create
    prediction = current_user.predictions.new(prediction_params)
    match = Match.find(prediction_params[:match_id])
    return head(:bad_request) if match.locked?
    prediction.attributes = prediction_params
    if match.knock_out?
      if prediction.team_1_goals != prediction.team_2_goals
        prediction.winner_id = nil
      else
        prediction.decider = Match::DECIDER_TYPE_PENALTY
      end
    end
    prediction.save!
    render status: :ok, json: prediction_response(prediction)
  end

  def update
    prediction = current_user.predictions.find_by(match_id: prediction_params[:match_id])
    match = Match.find(prediction_params[:match_id])
    return head(:bad_request) if match.locked?
    prediction.attributes = prediction_params
    if match.knock_out?
      if prediction.team_1_goals != prediction.team_2_goals
        prediction.winner_id = nil
      else
        prediction.decider = Match::DECIDER_TYPE_PENALTY
      end
    end
    prediction.save!
    render status: :ok, json: prediction_response(prediction)
  end

  private

  def prediction_params
    @prediction_params ||= params.require(:prediction).permit(:match_id, :team_1_goals, :team_2_goals, :decider, :winner_id)
  end

  def prediction_response(prediction)
    {
      id: prediction.id,
      summary: prediction.summary_text,
      total_pending: total_pending,
      completed_this_day: completed_this_day(prediction.match.kick_off)
    }
  end

  def total_pending
    Match.unlocked.count - current_user.predictions.where(match: Match.unlocked).count
  end

  def completed_this_day(day)
    matches = Match.unlocked.where(kick_off: day.beginning_of_day..day.end_of_day)
    current_user.predictions.where(match: matches).count
  end
end