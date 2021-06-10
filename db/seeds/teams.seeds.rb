puts 'Seeding Teams'
[
  { full_name: 'Turkey', short_name: 'TUR' },
  { full_name: 'Italy', short_name: 'ITA' },
  { full_name: 'Wales', short_name: 'WAL' },
  { full_name: 'Switzerland', short_name: 'SUI' },
  { full_name: 'Denmark', short_name: 'DEN' },
  { full_name: 'Finland', short_name: 'FIN' },
  { full_name: 'Belgium', short_name: 'BEL' },
  { full_name: 'Russia', short_name: 'RUS' },
  { full_name: 'Netherlands', short_name: 'NED' },
  { full_name: 'Ukraine', short_name: 'UKR' },
  { full_name: 'Austria', short_name: 'AUT' },
  { full_name: 'North Macedonia', short_name: 'MKD' },
  { full_name: 'England', short_name: 'ENG' },
  { full_name: 'Croatia', short_name: 'CRO' },
  { full_name: 'Scotland', short_name: 'SCO' },
  { full_name: 'Czech Republic', short_name: 'CZE' },
  { full_name: 'Spain', short_name: 'ESP' },
  { full_name: 'Sweden', short_name: 'SWE' },
  { full_name: 'Poland', short_name: 'POL' },
  { full_name: 'Slovakia', short_name: 'SVK' },
  { full_name: 'Hungary', short_name: 'HUN' },
  { full_name: 'Portugal', short_name: 'POR' },
  { full_name: 'France', short_name: 'FRA' },
  { full_name: 'Germany', short_name: 'GER' },
].each do |team|
  Team.create!(full_name: team[:full_name], short_name: team[:short_name])
end

Team.all.each do |team|
  team.flag.attach(
    io: Rails.root.join("app/assets/images/flags/#{team.short_name.downcase}.png").open,
    filename: "#{team.full_name}.png"
  )
end