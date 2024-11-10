class Order < ApplicationRecord
  belongs_to :user
  has_many :portion_orders, dependent: :destroy
  has_many :portions, through: :portion_orders

  enum :status, { :open => 2, :canceled => 5, :waiting_cook_confirmation => 7, :cooking => 9, :ready => 11, :delivered => 13 }, default: :open

  validates :phone_number, presence: true, unless: -> { email.present? }
  validates :email, presence: true, unless: -> { phone_number.present? }
  validate :valid_cpf, if: -> { cpf.present? }
  validates :email , format: { with: Devise.email_regexp }, if: -> { email.present? }

  private

  def valid_cpf
    unless CPF.valid?(cpf)
      errors.add(:cpf, 'não é válido')
    end
  end

end
