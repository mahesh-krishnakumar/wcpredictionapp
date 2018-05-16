class UserController < ApplicationController
  def dashboard
    @matches = Match.all
  end
end
