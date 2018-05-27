ActiveAdmin.register Match do
  permit_params :team_1_id, :team_2_id, :venue, :kick_off, :team_1_goals, :team_2_goals, :stage, :decider

  scope :group_stage
  scope :knock_out_stage

  form do |f|
    f.inputs 'Match Details' do
      f.input :team_1
      f.input :team_2
      f.input :venue
      f.input :kick_off, as: :date_time_picker, datepicker_options: { start_date: '2018-06-1', min_date: '2018-06-14', max_date: '2018-07-15', step: 30 }
      f.input :stage, as: :select, collection: Match.valid_stages, include_blank: false
    end

    f.inputs 'Match Results' do
      f.input :team_1_goals
      f.input :team_2_goals
      f.input :decider, as: :select, collection: Match.valid_decider_types
    end

    f.actions
  end
end