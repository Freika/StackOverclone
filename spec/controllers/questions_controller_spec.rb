require 'rails_helper'

describe QuestionsController do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'returns array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'returns one question object' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show template' do
      expect(response).to render_template :show, id: question
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns new Question object to @question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'renders new template' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, id: question }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit template' do
      expect(response).to render_template :edit, id: question
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by 1
      end

      it 'redirects to created question view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t save new question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 'render new template again' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns requested question record to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'updates @question attributes' do
        patch :update, id: question, question: { title: 'Brand new title', body: 'Shiny body' }
        question.reload
        expect(question.title).to eq 'Brand new title'
        expect(question.body).to eq 'Shiny body'
      end

      it 'redirects to updated @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before do
        patch :update, id: question, question: { title: 'Brand new title', body: nil }
      end

      it 'does not change @question attributes' do
        question.reload
        expect(question.title).to eq 'Title'
        expect(question.body).to eq 'Body'
      end

      it 'render edit template again' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { question }

    it 'deletes question' do
      expect { delete :destroy, id: question }.to change(Question, :count).by -1
    end

    it 'redirect to index template' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end
end
