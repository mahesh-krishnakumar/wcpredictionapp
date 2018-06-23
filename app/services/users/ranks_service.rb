module Users
  class RanksService
    def initialize(user)
      @user = user
      @groups = @user.groups
    end

    def ranks
      # First the global rank
      ranks = {}
      ranks[:global] = begin
        user_rank = UserRank.where(user: @user, group_id: 0).first
        { rank: user_rank.rank, points: user_rank.points }
      end

      @groups.each do |group|
        ranks[group.id] = begin
          user_rank = UserRank.where(user: @user, group_id: group.id).first
          { rank: user_rank.rank, points: user_rank.points }
        end
      end

      ranks
    end
  end
end