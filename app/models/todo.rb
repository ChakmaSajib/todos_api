class Todo < ApplicationRecord
    # validation
    validates_presence_of :title, :created_by

    # model association 
    has_many :items, dependent: :destroy
end
