require 'rails_helper'

describe AnswersController do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user_id: @user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user

      it 'saves new answers in database' do
        expect { post :create, question_id: question, user_id: @user, answer: attributes_for(:answer) }.to change(@user.answers, :count).by 1
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

    context 'unauthenticated user' do
      it 'redirected to sign in page' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to new_user_session_path
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
    let!(:another_answer) { create(:answer, question: question) }

    context 'answer author' do
      it 'correctly deletes answer' do
        answer.update(user: @user)
        expect { delete :destroy, id: answer, question_id: question }.to change(Answer, :count).by(-1)
      end
    end

    context 'other user' do
      it 'does not change answers count' do
        expect { delete :destroy, id: another_answer, question_id: question }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, id: another_answer, question_id: question
        expect(response).to redirect_to question
      end
    end
  end

end
