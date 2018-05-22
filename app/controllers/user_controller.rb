class UserController < ApplicationController
  before_action :authenticate_user!
  def dashboard
    @upcoming_matches = Match.open_for_prediction.group_by_day { |m| m.kick_off }
    @completed_matches = Match.locked_for_prediction.group_by_day { |m| m.kick_off }
  end
end
