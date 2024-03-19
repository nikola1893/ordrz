class Order < ApplicationRecord
  belongs_to :user
  has_many :stops, dependent: :destroy

  accepts_nested_attributes_for :stops, allow_destroy: true
end
