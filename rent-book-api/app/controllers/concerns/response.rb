module Response
  def response_json message, status, data = {}
    render json: {
      messages: message,
      data: data
    }, status:  status
  end
end
