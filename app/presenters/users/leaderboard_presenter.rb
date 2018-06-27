module Users
  class LeaderboardPresenter
    def change_in_rank_icon(change_in_rank)
      if change_in_rank.negative?
        'fa-caret-down leaderboard__rank-icon leaderboard__rank-icon--red'
      elsif change_in_rank.positive?
        'fa-caret-up leaderboard__rank-icon leaderboard__rank-icon--green'
      else
        'fa-minus leaderboard__rank-icon leaderboard__rank-icon--grey'
      end
    end
  end
end