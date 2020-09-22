class Api::V1::Admin::RegisterBookDetailsController < ApplicationController
    before_action :authenticate_request!
    authorize_resource
    before_action :load_register_book_detail, only: :index
  
    def index
      json_response @register_book_detail
    end
  
    private
  
    def load_register_book_detail
      @register_book_detail = RegisterBook.find_by!(id: params[:register_book_id]).register_book_details
    end
  end
  