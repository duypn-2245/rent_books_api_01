require "rails_helper"

RSpec.describe Api::V1::RegisterBooksController, type: :controller do
  include_examples "login current_user", :user

  let!(:book){FactoryBot.create(:book, quantity: 20)}
  let!(:register_book){FactoryBot.create(:register_book)}
  let!(:register_book_detail){FactoryBot.create(:register_book_detail)}

  describe "GET #index" do
    subject{get :index}

    include_examples "response http status", :ok
    include_examples "index valid json", "register_books", 1
  end

  describe "POST #create" do
    context "with valid params" do
      subject do
        post :create, params: {register_book: {start_date: Time.current,
                                               intended_end_date: (Time.current + 10),
                                               register_book_details_attributes: [{book_id: book.id,
                                                                                   quantity: book.quantity - 1,
                                                                                   rent_cost: book.rent_cost}]}}
      end
      include_examples "response http status", :created
      include_examples "count after action", RegisterBook, 1
    end

    context "with invalid params" do
      subject do
        post :create, params: {register_book: {start_date: Time.current,
                                               intended_end_date: (Time.current - 10),
                                               register_book_details_attributes: [{book_id: book.id,
                                                                                   quantity: book.quantity - 1,
                                                                                   rent_cost: book.rent_cost}]}}
      end

      include_examples "response http status", :unprocessable_entity
      include_examples "count after action", RegisterBook, 0
    end

    context "Must have at least one book" do
      subject do
        post :create, params: {register_book: {start_date: Time.current,
                                               intended_end_date: (Time.current - 10),
                                               register_book_details_attributes: []}}
      end

      include_examples "response http status", :unprocessable_entity
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      subject do
        put :update, params: {id: register_book.id,
                              status: RegisterBook.statuses[:canceled]}
      end

      include_examples "response http status", :ok
      it "update successfull" do
        subject
        expect(register_book.reload.canceled?).to eq(true)
      end
    end

    context "with invalid params" do
      subject do
        put :update, params: {id: register_book.id,
                              status: RegisterBook.statuses[:approved]}
      end

      include_examples "response http status", :forbidden
      it "update failed" do
        subject
        expect(register_book.reload.canceled?).to eq(false)
      end
    end
  end
end
