ActiveAdmin.register User do
  permit_params :name, :nick_name, group_ids: []

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
    end
  end

  filter :email
  # filter :groups

  form do |f|
    f.inputs do
      f.input :name
      f.input :nick_name
      f.input :group_ids, as: :select, collection: Group.all, input_html: {:multiple => true}
    end
    f.actions
  end
end
