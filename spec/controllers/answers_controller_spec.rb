require 'rails_helper'

describe AnswersController do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new answers in database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.to change(Answer, :count).by 1
      end

      it 'redirects to parent question view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t save new answer' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end
    end
  end

end
