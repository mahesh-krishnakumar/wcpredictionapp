after 'teams' do
  puts 'Seeding Matches'

  require 'csv'

  fixture_csv = File.read(Rails.root.join('WCFixtures_UTC.csv'))

  csv = CSV.parse(fixture_csv, headers: true)

  csv.each do |row|
    match_details = row.to_hash
    Match.create!(
      team_1: Team.find_by(full_name: match_details['team_1']),
      team_2: Team.find_by(full_name: match_details['team_2']),
      venue: match_details['venue'],
      kick_off: DateTime.parse(match_details['kick_off']),
      stage: Match::STAGE_GROUP
    )
  end

  Match.where(stage: Match::STAGE_GROUP).first.update!(team_1_goals: 2, team_2_goals: 1)
end
