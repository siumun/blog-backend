ActiveAdmin.register Post do
  preserve_default_filters!
  remove_filter :top_image_attachment, :top_image_blob

  permit_params :title, :excerpt, :body, :publication_date, :status, :top_image

   before_create do |post|
    post.admin_user = current_admin_user
  end


  form do |f|
    f.inputs do
      f.input :title
      f.input :excerpt
      f.input :body
      f.input :publication_date
      f.input :status
      f.input :top_image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :excerpt
      row :body
      row :publication_date
      row :status
      row :top_image do |post|
        if post.top_image.attached?
          image_tag url_for(post.top_image), width:300
        end
      end
    end
  end
end