class Question < ActiveRecord::Base
  validates :title, :body, presence: true
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  accepts_nested_attributes_for :attachments, allow_destroy: true
end
