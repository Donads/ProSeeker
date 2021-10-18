class AdminController < ApplicationController
  before_action :require_admin_login

  def manage_records; end
end
