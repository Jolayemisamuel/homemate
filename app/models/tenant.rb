class Tenant < ApplicationRecord
  has_many :users
  has_many :contacts, as: :contactable, dependent: :destroy

  has_many :tenancies, dependent: :restrict_with_exception
  has_many :tenant_checks, dependent: :destroy
  has_many :mandates, dependent: :destroy
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :deposits

  def self.balance
    :invoices.where(issued: true).sum(:amount)
  end

  def self.pending_balance
    :invoices.where(issued: false).sum(:amount)
  end

  def self.active_tenancy
    :tenancies.active
  end

  def self.future_tenancy
    :tenancies.future
  end

  def self.current_tenancy
    if self.active_tenancy.present?
      return self.active_tenancy
    else
      return self.future_tenancy
    end
  end

  def self.has_active_mandate
    :mandates.present?
  end
end
