require "rails_helper"

RSpec.describe Api::V1::CommentsController, type: :controller do
  let!(:user){FactoryBot.create(:user)}
  let!(:book){FactoryBot.create(:book)}
  let!(:comment){FactoryBot.create(:comment, user_id: user.id, book_id: book.id)}
  let!(:correct_comment){FactoryBot.create(:comment, user_id: current_user.id, book_id: book.id)}

  include_examples "login current_user", :user
  before{comment}

  describe "GET #index" do
    subject{get :index, params: {book_id: book.id}}

    include_examples "response http status", :ok
    include_examples "index valid json", "comments", 2
  end

  describe "POST #create" do
    context "with valid params" do
      subject{post :create, params: {book_id: comment.book_id, content: "example content", parent_id: comment.id}}

      include_examples "response http status", :created
      include_examples "count after action", Comment, 1

      it "it a children comment" do
        body = JSON.parse(subject.body)
        expect(body["comment"]["parent_id"]).to eq(comment.id)
      end
    end

    context "with invalid params" do
      subject do
        post :create, params: {book_id: comment.book_id, content: nil, parent_id: comment.id}
      end

      include_examples "response http status", :unprocessable_entity
      include_examples "count after action", Comment, 0
    end
  end

  describe "PUT #update" do
    context "with invalid params" do
      subject do
        post :create, params: {book_id: comment.book_id,
                               id: comment.id,
                               content: nil,
                               parent_id: comment.parent_id}
      end

      include_examples "response http status", :unprocessable_entity
      include_examples "count after action", Comment, 0
    end

    context "with valid params" do
      context "comment.user_id incorrect with current user" do
        subject do
          put :update, params: {book_id: comment.book_id,
                                id: comment.id,
                                content: "example content"}
        end

        include_examples "response http status", :forbidden
      end

      context "comment.user_id correct with current user" do
        subject do
          put :update, params: {book_id: correct_comment.book_id,
                                id: correct_comment.id,
                                content: "example content"}
        end

        include_examples "response http status", :ok

        it "update successfull" do
          subject
          expect(correct_comment.reload.content).to eq("example content")
          expect(response.body).to eq({comment: CommentSerializer.new(correct_comment.reload).attributes}.to_json)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "comment.user_id incorrect with current user" do
      subject{delete :destroy, params: {book_id: comment.book_id, id: comment.id}}

      include_examples "response http status", :forbidden
    end

    context "comment.user_id correct with current user" do
      subject{delete :destroy, params: {book_id: correct_comment.book_id, id: correct_comment.id}}

      include_examples "response http status", :no_content

      it "delete successfull" do
        subject
        expect(correct_comment.reload.delete).not_to eq(nil)
      end
    end
  end
end
