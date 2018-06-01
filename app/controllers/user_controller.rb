class UserController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @presenter = Users::DashboardPresenter.new(current_user)
  end

  def leaderboard
    @groups = current_user.groups
    @leaderboards = @groups.each_with_object({}) do |group, leaderboard|
      leaderboard[group.id] = Groups::StandingsTableService.new(group).table
    end
    @global_leaderboard = Groups::StandingsTableService.new.table
  end
end
