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
end












