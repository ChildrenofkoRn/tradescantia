module Dashboard::UsersHelper
  TYPES = %w( User Admin ).freeze

  def validate_type?(value)
    TYPES.include?(value)
  end
end
