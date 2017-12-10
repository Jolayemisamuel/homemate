class Tenant < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :contacts, as: :contactable

  has_many :tenancies
  has_many :tenant_checks, dependent: true
  has_many :mandates
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :deposits

  def self.balance
    return :invoices.where(issued: true).sum(:amount)
  end

  def self.pending_balance
    return :invoices.where(issued: false).sum(:amount)
  end

  def self.current_tenancy
    return :tenancies.order(started_on: :desc).last
  end

  def self.has_active_mandate
    return :mandates.where(active: true).count >= 1
  end
end
