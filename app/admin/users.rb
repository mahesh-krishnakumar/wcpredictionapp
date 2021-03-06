ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :name, :nick_name, :team_id, group_ids: []

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :groups do |user|
      div do
        user.groups.each do |group|
          span do
            link_to group.name, [:admin, group]
          end
        end
      end
    end
    column :team
    actions
  end

  show do |user|
    attributes_table do
      row :email
      row :name
      row :nick_name
      row :groups do
        div do
          user.groups.each do |group|
            span do
              link_to group.name, [:admin, group]
            end
          end
        end
      end
      row :team
    end
  end

  filter :email
  filter :team
  filter :groups

  form do |f|
    f.inputs do
      f.input :email
      f.input :name
      f.input :nick_name
      f.input :group_ids, as: :select, collection: Group.all, input_html: {:multiple => true}
      f.input :team
      unless f.object.persisted?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end
end
