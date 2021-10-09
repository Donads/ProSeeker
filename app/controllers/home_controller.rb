class HomeController < ApplicationController
  before_action :professional_must_fill_profile

  def index; end
end
