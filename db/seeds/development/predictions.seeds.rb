after 'development:users', 'matches', 'development:knock_out_matches' do
  puts 'Seeding Predictions'

  group_match = Match.where(stage: Match::STAGE_GROUP).first
  User.all.each do |user|
    Prediction.create!(
      match: group_match,
      user: user,
      team_1_goals: rand(0..5),
      team_2_goals: rand(0..5)
    )
  end

  knock_out_match = Match.where.not(stage: Match::STAGE_GROUP).first
  User.all.each do |user|
    Prediction.create!(
      match: knock_out_match,
      user: user,
      team_1_goals: rand(0..5),
      team_2_goals: rand(0..5),
      decider: Match.valid_decider_types.sample
    )
  end

  # Create a result for predicted matches
  Match.where(stage: Match::STAGE_GROUP).first.update!(team_1_goals: 2, team_2_goals: 1)
  Match.where.not(stage: Match::STAGE_GROUP).first.update!(team_1_goals: 2, team_2_goals: 1, decider: Match::DECIDER_TYPE_EXTRA_TIME)
end