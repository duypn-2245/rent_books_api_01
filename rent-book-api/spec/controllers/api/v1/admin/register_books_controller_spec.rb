require "rails_helper"

RSpec.describe Api::V1::Admin::RegisterBooksController, type: :controller do
  let!(:user){FactoryBot.create(:user)}
  let!(:book){FactoryBot.create(:book)}
  let!(:register_book){FactoryBot.create(:register_book, user: user)}
  let!(:register_book_details){FactoryBot.create(:register_book_detail, register_book: register_book, book: book)}

  include_examples "login", :admin

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
