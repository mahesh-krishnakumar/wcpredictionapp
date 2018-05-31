module Users
  class RanksService
    def initialize(user)
      @user = user
      @groups = @user.groups
    end

    def ranks
      # First the global rank
      ranks = {}
      ranks[:global] = Groups::StandingsTableService.new.standing(@user)

      @groups.each do |group|
        ranks[group.id] = Groups::StandingsTableService.new(group).standing(@user)
      end

      ranks
    end
  end
end