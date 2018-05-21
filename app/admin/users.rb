ActiveAdmin.register User do
  controller do
    actions :all, except: [:edit, :destroy]
  end
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    actions
  end

  filter :email

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :group
    end
    f.actions
  end
end
