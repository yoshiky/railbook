module ApplicationHelper

  #自作image_tagテスト
  def book_image_tag
    image_tag book_image_path(
      :book_id => 1,
      :file => "title_imag.jpg"
    )
  end
end
