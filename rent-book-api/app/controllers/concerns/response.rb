module Response
  def response_json message, status, data = {}
    render json: {
      messages: message,
      data: data
    }, status:  status
  end

  def json_response object, meta = {}, status = :ok
    render json: object, meta: meta, status: status
  end

  def json_response_with_custom_serializer object, serializer, meta = {} , status = :ok
    render json: object, each_serializer: serializer, meta: meta, status: status
  end

  def response_status status
    render status: status
  end
end
