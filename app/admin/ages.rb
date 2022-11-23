ActiveAdmin.register Age do
    permit_params :age_name
  
    index do
      selectable_column
      id_column
      column :age_name
      column :created_at
      column :updated_at
      column :created_by
      column :updated_by
      actions
    end
    filter :age_name
    filter :created_at
    filter :updated_at
    filter :created_by
    filter :updated_by
  
    form do |f|
      f.semantic_errors
      f.inputs do

      end
      f.actions
    end
  
end