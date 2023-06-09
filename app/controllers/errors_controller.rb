class ErrorsController < ApplicationController

  SUPPORTED_ERRORS = [404, 422, 500].freeze

  def show
    @exception = request.env["action_dispatch.exception"]
    @status = @exception.try(:status_code) ||
                    ActionDispatch::ExceptionWrapper.new(request.env, @exception).status_code

    render view_for_error(@status), status: @status, content_type: 'text/html'
  end

  private

  def view_for_error(status)
    SUPPORTED_ERRORS.include?(status) ? status.to_s : 'error'
  end

end
