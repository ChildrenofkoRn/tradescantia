module ApiHelpers
  def ref_headers
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT'       => 'application/json' }
  end

  def json(key = "data")
    @json ||= JSON.parse(response.body)[key]
  end

  def do_request(action, path, ...)
    send(action, path, ...)
  end
end
