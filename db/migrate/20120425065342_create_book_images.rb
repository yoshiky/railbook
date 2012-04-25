class CreateBookImages < ActiveRecord::Migration
  def change
    create_table :book_images do |t|
      t.integer :book_id
      t.string :image_name
      t.integer :display_order
      t.timestamps
      t.date :deleted_at
    end
  end
end
