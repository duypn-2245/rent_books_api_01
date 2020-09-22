require "rails_helper"

RSpec.describe Api::V1::Admin::RegisterBooksController, type: :controller do
  let!(:user){FactoryBot.create(:user)}
  let!(:book){FactoryBot.create(:book)}
  let!(:register_book){FactoryBot.create(:register_book, user: user)}
  let!(:register_book_details){FactoryBot.create(:register_book_detail, register_book: register_book, book: book)}
  let(:filter_expected_repsonse) do
    {register_books: [RegisterBookSerializer.new(register_book).attributes],
     meta: {page: 1, per_page: 10, total_page: 1}}.to_json
  end
  include_examples "login", :admin

  describe "GET #index" do
    context "filter by start date" do
      subject{get :index, params: {search: {start_date_cont: register_book.start_date}}}

      it "search register book successfully" do
        subject
        expect(response.body).to eq(filter_expected_repsonse)
      end

      include_examples "response http status", :ok
      include_examples "index valid json", "register_books", 1
    end

    context "filter between start date" do
      subject do
        get :index, params: {search: {start_date_gteq: register_book.start_date,
                                      start_date_lteq: register_book.start_date}}
      end

      it "search register book successfully" do
        subject
        expect(response.body).to eq(filter_expected_repsonse)
      end

      include_examples "response http status", :ok
      include_examples "index valid json", "register_books", 1
    end
  end

  describe "PUT #update" do
    context "approve register book" do
      subject{put :update, params: {id: register_book.id, status: "approved"}}

      it "update successfully" do
        subject
        body = JSON.parse(subject.body)
        expect(response.body["register_book"]).to be_present
        expect(body["register_book"]["status"]).to eq("approved")
      end

      include_examples "response http status", :ok
    end

    context "reject register book" do
      subject{put :update, params: {id: register_book.id, status: "rejected"}}

      it "update successfully" do
        subject
        body = JSON.parse(subject.body)
        expect(response.body["register_book"]).to be_present
        expect(body["register_book"]["status"]).to eq("rejected")
      end

      include_examples "response http status", :ok
    end
  end
end
