require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question_id: question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new answers in database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count).by 1
      end

      it 'correctly assigns to user' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(Answer.last.user).to eq @user
      end

      it 'correctly assigns to question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(Answer.last.question).to eq question
      end

      it 'redirects to parent question view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it "doesn't save new answer" do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    it 'correctly deletes answer' do
      answer = create(:answer, question_id: question)
      expect { delete :destroy, id: answer, question_id: question }.to change(Answer, :count).by -1
    end
  end

end
