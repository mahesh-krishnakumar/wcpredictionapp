ActiveAdmin.register User do
  controller do
    actions :all, except: [:edit, :destroy]
  end
  permit_params :email, :password, :password_confirmation, :group_id, :name, :nick_name

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :group
    actions
  end

  filter :email
  filter :group

  form do |f|
    f.inputs do
      f.input :email
      f.input :name
      f.input :nick_name
      f.input :password
      f.input :password_confirmation
      f.input :group
    end
    f.actions
  end
end
