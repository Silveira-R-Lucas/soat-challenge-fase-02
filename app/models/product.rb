class Product < ApplicationRecord
  has_many_attached :images
  before_create validates_presence_of :name, :category, :description, :price, :quantity, :images
  validates_numericality_of :price, greater_than_or_equal_to: 0
end
