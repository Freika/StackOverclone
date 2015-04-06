class Answer < ActiveRecord::Base
  validates :body, presence: true
  belongs_to :question
  belongs_to :user

  def mark_as_solution
    self.question.answers.update_all(is_solution: false)
    self.update(is_solution: true)
  end
end
