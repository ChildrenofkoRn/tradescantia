module Dashboard::UsersHelper
  TYPES = %w( User Admin ).freeze

  def valid_type?(value)
    TYPES.include?(value)
  end
end
