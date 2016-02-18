require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { question = questions.first }
      let!(:answer) { create(:answer, question: question, user: user) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at user_id).each do |attr|
        it "question object contains #{attr}" do

          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let(:user) { create :user }
    let(:question) {create(:question, user: user)}

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }
      let!(:answer) { create :answer, question: question, user: user }
      let!(:comment) { create :comment, commentable: question }
      let!(:attachment) { create :attachment, attachable: question }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at user_id).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/answers")
        end

        %w(id body question_id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body user_id commentable_id commentable_type created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      context 'with valid attributes' do
        it 'returns 200 status code' do
          post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:question)
          expect(response).to be_success
        end

        it 'change question count' do
          expect { post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:question) }.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status' do
          post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:invalid_question)
          expect(response.status).to eql 422
        end

        it 'doesn\'t change question count' do
          expect { post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        end
      end
    end
  end
end