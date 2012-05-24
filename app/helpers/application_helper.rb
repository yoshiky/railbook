module ApplicationHelper

  #自作image_tagテスト
  def book_image_tag(book_id,book_image_id,book_image_image_name,width)
    image_tag book_image_path(
      :id => book_id,
      :book_id => book_image_id,
      :file => book_image_image_name
    ),:width => width
  end
end
