class ErrorsController < ApplicationController

  SUPPORTED_ERRORS = [404, 422, 500].freeze

  def show
    @exception = request.env["action_dispatch.exception"]
    @error = @exception.try(:status_code) ||
                    ActionDispatch::ExceptionWrapper.new(
                      request.env, @exception
                    ).status_code

    render view_for_error(@error), status: @error, content_type: 'text/html'
  end

  private

  def view_for_error(code)
    SUPPORTED_ERRORS.fetch(code, 404).to_s
  end

end
