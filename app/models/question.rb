class Question < ActiveRecord::Base
  validates :title, :body, presence: true
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user
end
