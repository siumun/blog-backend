class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.text :excerpt
      t.text :body
      t.datetime :publication_date
      t.integer :view_count, default: 0
      t.integer :status, default:0, nil:false
      t.references :admin_user, null: false, foreign_key: true

      t.timestamps

      t.index [:posts, :slug], unique: true
    end
  end
end
