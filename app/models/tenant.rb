class Tenant < ApplicationRecord
  has_many :user_associations, as: :associable, dependent: :restrict_with_exception
  has_many :contacts, as: :contactable, dependent: :destroy

  has_many :tenancies, dependent: :restrict_with_exception
  has_many :tenant_checks, dependent: :destroy
  has_many :mandates, dependent: :destroy
  has_many :invoices
  has_many :transactions
  has_many :deposits

  validates :name, presence: true

  def balance
    transactions.where(processed: true).sum(:amount)
  end

  def readable_balance
    Settings.currency + balance.abs
  end

  def balance_is_credit?
    balance < 0
  end

  def pending_balance
    transactions.sum(:amount)
  end

  def readable_pending_balance
    Settings.currency + pending_balance.abs
  end

  def pending_balance_is_credit?
    pending_balance < 0
  end

  def active_tenancy
    tenancies.active.first
  end

  def future_tenancy
    tenancies.future.first
  end

  def current_tenancy
    if active_tenancy.present?
      active_tenancy
    else
      future_tenancy
    end
  end

  def has_active_mandate?
    mandates.present?
  end
end
