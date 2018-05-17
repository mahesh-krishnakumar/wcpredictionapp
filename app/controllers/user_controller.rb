class UserController < ApplicationController
  def dashboard
    @matches_by_date = Match.all.group_by_day { |m| m.kick_off }
  end
end
