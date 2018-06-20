ActiveAdmin.register Group do
  permit_params :name, :code, :created_at

  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :code
    end
    f.actions
  end
end
