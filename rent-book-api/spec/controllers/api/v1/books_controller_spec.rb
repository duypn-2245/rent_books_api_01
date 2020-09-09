require "rails_helper"
require "spec_helper"

RSpec.describe Api::V1::BooksController, type: :controller do
  let(:book){FactoryBot.create(:book)}

  include_examples "login", :user

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
end
