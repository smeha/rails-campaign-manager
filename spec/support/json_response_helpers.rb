module JsonResponseHelpers
  def parsed_json_body
    body = JSON.parse(response.body)
    body.is_a?(String) ? JSON.parse(body) : body
  end
end
