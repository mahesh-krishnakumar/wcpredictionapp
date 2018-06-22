module OneOff
  class CreateUserRankEntriesForGroups
    def execute
      @users = User.all
      @users.each do |user|
        ranks = Users::RanksService.new(user).ranks
        ranks.each do |group, rank_points|
          if group == :global
            UserRank.create!(group_id: 0, user: user, rank: rank_points[:rank], points: rank_points[:points])
          else
            UserRank.create!(group_id: group, user: user, rank: rank_points[:rank], points: rank_points[:points])
          end
        end
      end
    end
  end
end