require 'rails_helper'

describe Answer do
  let(:question)      { create(:question) }
  let(:first_answer)  { create(:answer, question: question) }
  let(:second_answer) { create(:answer, question: question) }
  let(:third_answer)  { create(:answer, question: question) }

  it { should validate_presence_of :body }
  it { should belong_to(:question) }

  it '#mark_as_solution updates is_solution attribute' do
    first_answer.mark_as_solution
    expect(Answer.find(first_answer.id).is_solution).to eq true
  end

  it '#mark_as_solution update others answers is_solution to be false' do
    first_answer.mark_as_solution
    expect(Answer.find(first_answer.id).is_solution).to eq true

    third_answer.mark_as_solution

    expect(Answer.find(third_answer.id).is_solution).to eq true
    expect(Answer.find(first_answer.id).is_solution).to eq false
    expect(Answer.find(second_answer.id).is_solution).to eq false

  end
end
