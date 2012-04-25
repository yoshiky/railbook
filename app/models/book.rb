class Book < ActiveRecord::Base
  has_many :reviews
  has_many :book_images
end
