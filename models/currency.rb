require 'active_model'
class Currency
  include ActiveModel::Model
  include Virtus.model
  attribute :amount, Float
  attribute :base, String
  attribute :to, String

  validates :base, presence: true
  validates :to, presence: true
  validates :amount, numericality: true, allow_blank: true
end
