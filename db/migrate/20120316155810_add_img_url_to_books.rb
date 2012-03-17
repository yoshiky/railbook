class AddImgUrlToBooks < ActiveRecord::Migration
  def change
    add_column :books, :img_url, :string
  end
end
