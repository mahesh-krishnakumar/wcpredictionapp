puts 'Seeding Teams'
[
  { full_name: 'Russia', short_name: 'RUS' },
  { full_name: 'Saudi Arabia', short_name: 'KSA' },
  { full_name: 'Egypt', short_name: 'EGY' },
  { full_name: 'Uruguay', short_name: 'URU' },
  { full_name: 'Portugal', short_name: 'POR' },
  { full_name: 'Spain', short_name: 'ESP' },
  { full_name: 'Morocco', short_name: 'MAR' },
  { full_name: 'Iran', short_name: 'IRN' },
  { full_name: 'France', short_name: 'FRA' },
  { full_name: 'Australia', short_name: 'AUS' },
  { full_name: 'Peru', short_name: 'PER' },
  { full_name: 'Denmark', short_name: 'DEN' },
  { full_name: 'Argentina', short_name: 'ARG' },
  { full_name: 'Iceland', short_name: 'ISL' },
  { full_name: 'Croatia', short_name: 'CRO' },
  { full_name: 'Nigeria', short_name: 'NIG' },
  { full_name: 'Brazil', short_name: 'BRA' },
  { full_name: 'Switzerland', short_name: 'SUI' },
  { full_name: 'Costa Rica', short_name: 'CRC' },
  { full_name: 'Serbia', short_name: 'SRB' },
  { full_name: 'Germany', short_name: 'GER' },
  { full_name: 'Mexico', short_name: 'MEX' },
  { full_name: 'Sweden', short_name: 'SWE' },
  { full_name: 'Korea Republic', short_name: 'KOR' },
  { full_name: 'Belgium', short_name: 'BLG' },
  { full_name: 'Panama', short_name: 'PAN' },
  { full_name: 'Tunisia', short_name: 'TUN' },
  { full_name: 'England', short_name: 'ENG' },
  { full_name: 'Poland', short_name: 'POL' },
  { full_name: 'Senegal', short_name: 'SEN' },
  { full_name: 'Colombia', short_name: 'COL' },
  { full_name: 'Japan', short_name: 'JPN' }
].each do |team|
  Team.create!(full_name: team[:full_name], short_name: team[:short_name])
end

Team.all.each do |team|
  team.flag.attach(
    io: Rails.root.join("app/assets/images/flags/#{team.short_name.downcase}.png").open,
    filename: "#{team.full_name}.png"
  )
end
