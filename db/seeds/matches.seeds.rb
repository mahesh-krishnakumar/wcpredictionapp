puts 'Seeding Matches'

require 'csv'

fixture_csv = File.read(Rails.root.join('fifa-world-cup-2022.csv'))

csv = CSV.parse(fixture_csv, headers: true)

csv.each do |row|
  match_details = row.to_hash
  binding.pry
  Match.create!(
    team_1: Team.find_by(full_name: match_details['team_1']),
    team_2: Team.find_by(full_name: match_details['team_2']),
    venue: match_details['venue'],
    kick_off: DateTime.parse(match_details['kick_off']),
    stage: Match::STAGE_GROUP
  )
end

# and `unlock` just the first six matches for now
Match.all.limit(6).update_all(locked: false)
