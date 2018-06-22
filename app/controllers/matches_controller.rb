class MatchesController < ApplicationController
  def update_result
    raise ActionController::RoutingError.new('Not Found') unless params[:token] == ENV.fetch('MATCH_RESULT_UPDATE_TOKEN')
    @matches = Match.unlocked.order('kick_off DESC').where('kick_off < ?', Time.now)
  end

  def update
    @matches = Match.unlocked.order('kick_off DESC').where('kick_off < ?', Time.now).order('kick_off DESC').to_a
    match = @matches.select { |match| match.id == params[:id].to_i }.first
    match.attributes = match_params
    if match.valid?
      match.update!(match_params)
      redirect_to update_match_result_path(token: ENV.fetch('MATCH_RESULT_UPDATE_TOKEN'))
    else
      render 'update_result'
    end
  end

  def predictions
    @presenter = Users::DashboardPresenter.new(current_user)
    @match = Match.find(params[:id])
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.js
    end
  end

  private

  def match_params
    @match_params ||= params.require(:match).permit(:team_1_goals, :team_2_goals, :decider, :winner_id)
  end
end