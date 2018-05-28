after 'teams' do
  puts 'Seeding Knockout Matches'
  Match.create!(team_1: Team.find_by(short_name: 'FRA'),
                team_2: Team.find_by(short_name: 'GER'),
                stage: Match::STAGE_PRE_QUARTER,
                kick_off: 1.month.from_now)

  Match.create!(team_1: Team.find_by(short_name: 'ENG'),
                team_2: Team.find_by(short_name: 'ESP'),
                stage: Match::STAGE_QUARTER,
                kick_off: 1.month.from_now)

  # Make one knockout match complete

  Match.where.not(stage: Match::STAGE_GROUP).first.update!(team_1_goals: 2, team_2_goals: 1, decider: Match::DECIDER_TYPE_EXTRA_TIME)
end












