class VisitorUser

  def visitor?
    true
  end

  def method_missing(method_symbol, *args, &block)
    return false if method_symbol.to_s.end_with?('?')

    super(method_symbol, *args, &block)
  end

  def respond_to_missing?(method_symbol, include_private)
    return false if method_symbol.to_s.end_with?('?')

    super(method_symbol, include_private)
  end

end
