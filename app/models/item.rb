class Item < ApplicationRecord
  # validation 
  validates_presence_of :name
  # model association
  belongs_to :todo
end
