ActiveAdmin.register User do
  permit_params :name, :email, :password, :password_confirmation

    form do |f|
      f.inputs do
        f.input :name
        f.input :email
        f.input :password
        f.input :password_confirmation
      end

      f.actions
    end

    show do
      attributes_table do
        row :id
        row :name
        row :email
        row :created_at
      end

      panel "Favourite Posts" do
        table_for resource.favorites do
          column("Post Title") {|favourite| favourite.post.title}
          column :created_at
        end
      end
    end
end
