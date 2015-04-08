require 'rails_helper'

describe Answer do
  let(:question)      { create(:question) }
  let(:first_answer)  { create(:answer, question: question) }
  let(:second_answer) { create(:answer, question: question) }
  let(:third_answer)  { create(:answer, question: question) }

  it { should validate_presence_of :body }
  it { should belong_to(:question) }

  describe '#mark_as_solution' do
    it 'updates is_solution attribute' do
      first_answer.mark_as_solution
      expect(first_answer.is_solution).to be true
    end

    it 'updates others answers is_solution to be false' do
      first_answer.update!(is_solution: true)
      third_answer.mark_as_solution

      first_answer.reload
      second_answer.reload

      expect(third_answer.is_solution).to be true
      expect(first_answer.is_solution).to be false
      expect(second_answer.is_solution).to be false
    end
  end
end
