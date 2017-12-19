class TransactionsController < ApplicationController
  before_action :authenticate_user!, :require_tenant

  def index
    @transactions = current_user.tenant.transactions
  end
end