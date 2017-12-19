class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_landlord, except: [:index, :show]

  def index
    if current_user.is_tenant?
      @invoices = current_user.tenant.invoices.where(issued: true)
    elsif current_user.is_landlord?
      @invoices = Invoice.all
    else
      abort
    end
  end

  def show
    if current_user.is_tenant?
      @invoice = current_user.tenant.invoices.find(params[:id]).include(:transactions)

      unless @invoice.issued?
        flash[:error] = 'You are not authorised to visit this page'
        redirect_back root_path
      end
    elsif current_user.is_landlord?
      @invoice = Invoice.find(params[:id])
    else
      abort
    end
  end

  def new
    @invoice = Invoice.new
  end

  def create
  end

  def destroy
    @invoice.destroy

    redirect_back root_path
  end
end