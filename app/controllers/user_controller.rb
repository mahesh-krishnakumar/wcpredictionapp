class UserController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @upcoming_matches = Match.upcoming.group_by_day { |m| m.kick_off }
    @completed_matches = Match.completed.group_by_day { |m| m.kick_off }
    @results = Matches::PredictionResultService.new(current_user.group).results
  end

  def leaderboard
    @group = current_user.group
    @users = @group.users
    @leaderboard = Groups::StandingsTableService.new(@group).table
  end
end
