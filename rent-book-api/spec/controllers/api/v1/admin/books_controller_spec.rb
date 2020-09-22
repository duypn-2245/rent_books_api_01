require "rails_helper"

RSpec.describe Api::V1::Admin::BooksController, type: :controller do
  let!(:user){FactoryBot.create(:user)}
  let!(:book){FactoryBot.create(:book)}
  let!(:book1){FactoryBot.create(:book)}
  let(:params) do
    {id: book.id, title: book.title, description: book.description,
     author: book.author, quantity: book.quantity, rent_cost: book.rent_cost}
  end
  let!(:register_book){FactoryBot.create(:register_book, user: user)}
  let!(:register_book_details) do
    FactoryBot.create(:register_book_detail,
                      register_book: register_book, book: book)
  end
  let(:invalid_params){{id: book.id, title: ""}}
  let(:renter_expected_repsonse) do
    {register_book_details:
                                [{id: register_book_details.id, name: user.name,
                                  quantity: register_book_details.quantity,
                                  rent_cost: register_book_details.rent_cost,
                                  start_date: I18n.l(register_book.start_date, format: :date_month_year_concise),
                                  end_date: register_book.end_date,
                                  intended_end_date: I18n.l(register_book.intended_end_date, format: :date_month_year_concise)}],
     meta: {page: 1, per_page: 10, total_page: 1}}.to_json
  end

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

  describe "GET #book_renter" do
    context "get book renter" do
      subject{get :book_renter, params: {id: book.id}}

      it "return list book renter successfully" do
        subject
        expect(response.body).to eq(renter_expected_repsonse)
      end

      include_examples "response http status", :ok
      include_examples "index valid json", "register_book_details", 1
    end
  end
end
