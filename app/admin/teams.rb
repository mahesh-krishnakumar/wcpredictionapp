ActiveAdmin.register Team do
  permit_params :full_name, :short_name, :flag

  filter :full_name
  filter :short_name

  show do
    attributes_table do
      row :full_name
      row :short_name
      row :flag do |team|
        team.flag.attached? ? image_tag(url_for(team.flag)) : '-'
      end
    end
  end

  form partial: 'form'
end
