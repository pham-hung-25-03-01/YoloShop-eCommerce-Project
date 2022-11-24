ActiveAdmin.register Event do
    permit_params :event_name

    index do
      selectable_column
      id_column
      column :event_name
      column :created_at
      column :updated_at
      column :updated_by
      actions
    end
end