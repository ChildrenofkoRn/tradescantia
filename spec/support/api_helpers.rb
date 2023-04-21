module ApiHelpers
  def ref_headers
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT'       => 'application/json' }
  end

  def json
    @json ||= JSON.parse(response.body)["data"]
  end

  def do_request(action, path, ...)
    send(action, path, ...)
  end
end
