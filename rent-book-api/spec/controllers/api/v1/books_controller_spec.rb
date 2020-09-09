require "rails_helper"

RSpec.describe Api::V1::BooksController, type: :controller do
  include_examples "login", :user

  let!(:book){FactoryBot.create(:book, quantity: 20)}
  let!(:register_book){FactoryBot.create(:register_book)}
  let!(:register_book_detail){FactoryBot.create(:register_book_detail)}

  describe "GET #index" do
    subject{get :index}

    before{book}

    include_examples "response http status", :ok
    include_examples "index valid json", "books", 1
  end

  describe "GET #show" do
    subject{get :show, params: {id: book.id}}

    include_examples "response http status", :ok

    it "returns valid JSON" do
      subject
      expect(response.body).to eq({book: BookSerializer.new(book).attributes}.to_json)
    end
  end

  describe "GET #hot_rentals" do
    subject{get :hot_rentals}

    include_examples "response http status", :ok

    include_examples "index valid json", "books", 1
  end
end
