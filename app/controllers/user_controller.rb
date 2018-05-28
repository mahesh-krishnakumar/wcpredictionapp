class UserController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @upcoming_matches = Match.upcoming.group_by_day { |m| m.kick_off }
    @completed_matches = Match.completed.group_by_day { |m| m.kick_off }
    @results = Matches::PredictionResultService.new(current_user.group).results
  end

  def leaderboard
    @groups = current_user.groups
    @leaderboards = @groups.each_with_object({}) do |group, leaderboard|
      leaderboard[group.id] = Groups::StandingsTableService.new(group).table
    end
  end
end
