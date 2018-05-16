after 'development:teams' do
  puts 'Seeding Matches'

  brazil = Team.find_by short_name: 'BRA'
  argentina = Team.find_by short_name: 'ARG'
  spain = Team.find_by short_name: 'SPA'
  portugal = Team.find_by short_name: 'POR'

  Match.create!(team_1: brazil, team_2: argentina, kick_off: 10.days.from_now)
  Match.create!(team_1: spain, team_2: portugal, kick_off: 11.days.from_now)
end