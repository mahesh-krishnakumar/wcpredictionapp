after 'development:users', 'matches', 'development:knock_out_matches' do
  puts 'Seeding Predictions'

  group_match = Match.where(stage: Match::STAGE_GROUP).first
  User.all.each do |user|
    Prediction.create!(
      match: group_match,
      user: user,
      team_1_goals: rand(0..7),
      team_2_goals: rand(0..7)
    )
  end

  knock_out_match = Match.where.not(stage: Match::STAGE_GROUP).first
  User.all.each do |user|
    decider = Match.valid_decider_types.sample
    team_1_goals = rand(0..5)
    team_2_goals = decider == Match::DECIDER_TYPE_PENALTY ? team_1_goals : ((0..7).to_a - [team_1_goals]).sample
    winner_id = decider == Match::DECIDER_TYPE_PENALTY ? [knock_out_match.team_1_id, knock_out_match.team_2_id].sample : nil
    Prediction.create!(
      match: knock_out_match,
      user: user,
      decider: decider,
      team_1_goals: team_1_goals,
      team_2_goals: team_2_goals,
      winner_id: winner_id
    )
  end

  # Create a result for predicted matches
  Match.where(stage: Match::STAGE_GROUP).first.update!(team_1_goals: 2, team_2_goals: 1)
  knock_out_match = Match.where.not(stage: Match::STAGE_GROUP).first
  knock_out_match.update!(team_1_goals: 2, team_2_goals: 2, decider: Match::DECIDER_TYPE_PENALTY, winner_id: knock_out_match.team_2_id)
end