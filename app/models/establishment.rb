class Establishment < ApplicationRecord
  has_many :opening_hours, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :menus, dependent: :destroy
  belongs_to :user
  
  before_validation :generate_code, on: :create

  validates :corporate_name, :trade_name, :cnpj, :email, :full_address, :phone_number, presence: :true
  validates :email , format: { with: Devise.email_regexp }
  validates :email , :cnpj, :code, uniqueness: true
  validate :valid_cnpj
  
  


  private

  def valid_cnpj
    unless CNPJ.valid?(cnpj)
      errors.add(:cnpj, 'não é válido')
    end
  end 

  def generate_code
    self.code = SecureRandom.alphanumeric(6)
  end
  
end
