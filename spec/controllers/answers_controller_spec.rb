require 'rails_helper'

describe AnswersController do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user_id: @user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user

      it 'saves new answers in database' do
        expect { post :create, question_id: question, user_id: @user, answer: attributes_for(:answer), format: :js }.to change(@user.answers, :count).by(1)
      end

      it 'correctly assigns to question' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(Answer.last.question).to eq question
      end

      it 'redirects to stay in current question page' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'unauthenticated user' do
      it 'redirected to sign in page' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response.status).to eq 401
      end
    end

    context 'with invalid attributes' do
      it "doesn't save new answer" do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:another_answer) { create(:answer, question: question) }

    context 'answer author' do
      it 'correctly deletes answer' do
        answer.update!(user: @user)
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'other user' do
      it 'does not change answers count' do
        expect { delete :destroy, id: another_answer, question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'renders destroy template' do
        delete :destroy, id: another_answer, question_id: question, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do

    context 'when tries to update own answer' do
      sign_in_user

      it 'assigns requested answer record to @answer' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'updates @answer attributes' do
        answer.update!(user: @user)
        patch :update, id: answer, question_id: question, answer: { body: 'Shiny body' }, format: :js
        answer.reload
        expect(answer.body).to eq 'Shiny body'
      end

      it 'render updated answer' do
        answer.update!(user: @user)
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end

      it 'assigns the question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end
    end

    context "when tries to update other's user answer" do
      sign_in_user

      let(:another_user) { create(:user) }
      let(:another_answer) { create(:answer, question: question, user_id: another_user) }

      it 'redirects to root' do
        patch :update, id: another_answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to redirect_to question
      end
    end

  end

end
