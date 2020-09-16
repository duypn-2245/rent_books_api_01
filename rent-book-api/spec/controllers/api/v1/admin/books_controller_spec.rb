require "rails_helper"
require "spec_helper"

RSpec.describe Api::V1::Admin::BooksController, type: :controller do
  let!(:book){FactoryBot.create(:book)}
  let!(:book1){FactoryBot.create(:book)}
  let(:params){{id: book.id, title: book.title, description: book.description,
                author: book.author, quantity: book.quantity,
                rent_cost: book.rent_cost}}
  let(:invalid_params){{id: book.id, title: ""}}

  include_examples "login", :admin

  describe "GET #index" do
    context "have search params" do
      subject{get :index, params: {search: {title_cont: book.title}}}

      it "search books" do
        subject
        expect(response.body).to eq({books: [BookSerializer.new(book).attributes],
                                     meta: {page: 1, per_page: 10, total_page: 1}}.to_json)
      end
      include_examples "response http status", :ok
    end

    context "have sort params" do
      subject{get :index, params: {sort: ["created_at desc"]}}

      it "sort books by recent" do
        subject
        expect(response.body).to eq({books: [BookSerializer.new(book1).attributes,
                                             BookSerializer.new(book).attributes],
                                     meta: {page: 1, per_page: 10, total_page: 1}}.to_json)
      end

      include_examples "response http status", :ok
    end
  end

  describe "GET #show" do
    subject{get :show, params: {id: book.id}}

    it "show book details" do
      subject
      expect(response.body).to eq({book: BookSerializer.new(book).attributes}.to_json)
    end

    include_examples "response http status", :ok
  end

  describe "POST #create" do
    context "with valid params" do
      subject{post :create, params: params}

      it "create new book successfuly" do
        subject
        expect(response.body["book"]).to be_present
      end
    end

    context "with invalid params" do
      subject{post :create, params: invalid_params}

      it "create new book failed" do
        subject
        expect(response.body["message"]).to be_present
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      subject{put :update, params: params}

      it "update book successfuly" do
        subject
        expect(response.body["book"]).to be_present
      end
    end

    context "with invalid params" do
      subject{put :update, params: invalid_params}

      it "update book failed" do
        subject
        expect(response.body["message"]).to be_present
      end
    end
  end

  describe "DELETE #update" do
    context "with valid params" do
      subject{put :update, params: {id: book.id}}

      it "delete book successfuly" do
        subject
        expect(response.body["book"]).to be_present
      end
    end

    context "with invalid params" do
      subject{put :update, params: {id: "ss"}}

      it "delete book failed" do
        subject
        expect(response.body["message"]).to be_present
      end
    end
  end
end
