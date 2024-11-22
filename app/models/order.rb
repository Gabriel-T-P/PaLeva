class Order < ApplicationRecord
  belongs_to :user
  has_many :portion_orders, dependent: :destroy
  has_many :portions, through: :portion_orders

  before_validation :set_alphamumeric_code_and_status, on: :create
  after_create :uses_promotions

  enum :status, { :canceled => 5, :waiting_cook_confirmation => 7, :cooking => 9, :ready => 11, :delivered => 13 }

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

  def set_alphamumeric_code_and_status
    self.code = SecureRandom.alphanumeric(8).upcase
    self.status = :waiting_cook_confirmation
    self.waiting_cook_confirmation_at = DateTime.current
  end

end
