class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_tenant, only: [:index]
  before_action :require_landlord, only: [:failed]

  def index
    @transactions = current_user.tenant.transactions.where(processed: true).where(failed: false)
  end

  def failed
    @transactions = Transaction.where(failed: true).all
  end
end