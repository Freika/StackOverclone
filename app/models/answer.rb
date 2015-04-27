class Answer < ActiveRecord::Base
  validates :body, presence: true
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :order_by_solution, -> { order(is_solution: :desc) }

  def mark_as_solution
    self.question.answers.update_all(is_solution: false)
    self.update(is_solution: true)
  end
end
