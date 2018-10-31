class ErrorsController < ApplicationController

  def not_found
    render(:status => 404)
    # ApplicationMailer.error_routes( current_user, request).deliver
  end

end
