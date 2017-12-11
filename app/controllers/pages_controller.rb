class PagesController < ApplicationController
  before_action :authenticate_user!
  layout 'application'

  def home
  end
end