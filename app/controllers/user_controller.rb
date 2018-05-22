class UserController < ApplicationController
  before_action :authenticate_user!
  def dashboard
    @upcoming_matches = Match.upcoming.group_by_day { |m| m.kick_off }
    @completed_matches = Match.completed.group_by_day { |m| m.kick_off }
  end
end
