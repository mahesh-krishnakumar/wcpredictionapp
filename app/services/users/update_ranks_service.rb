module Users
  class UpdateRanksService
    def execute
      generate_rank_tables
      UserRank.transaction do
        update_group_ranks
        update_global_ranks
      end
    end

    private

    def update_group_ranks
      @groups.each do |group|
        leaderboard = @leaderboards[group.id]
        group.users.pluck(:id).each do |user_id|
          user_rank = UserRank.find_or_create_by(group: group, user_id: user_id)
          previous_rank = user_rank.rank
          points = leaderboard.find { |entry| entry[0] == user_id }.second
          rank = leaderboard.find { |entry| entry[0] == user_id }.third
          change_in_rank = previous_rank.present? ? previous_rank - rank : 0
          user_rank.update!(points: points, rank: rank, change_in_rank: change_in_rank)
        end
      end
    end

    def update_global_ranks
      User.pluck(:id).each do |user_id|
        user_rank = UserRank.find_or_create_by(group_id: 0, user_id: user_id)
        previous_rank = user_rank.rank
        points = @global_leaderboard.find { |entry| entry[0] == user_id }.second
        rank = @global_leaderboard.find { |entry| entry[0] == user_id }.third
        change_in_rank = previous_rank.present? ? previous_rank - rank : 0
        user_rank.update!(points: points, rank: rank, change_in_rank: change_in_rank)
      end
    end

    def generate_rank_tables
      @groups = Group.all
      @leaderboards = @groups.each_with_object({}) do |group, leaderboard|
        leaderboard[group.id] = Groups::StandingsTableService.new(group).table
      end
      @global_leaderboard = Groups::StandingsTableService.new.table
    end
  end
end