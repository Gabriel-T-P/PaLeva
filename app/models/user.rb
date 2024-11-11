class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :first_name, :last_name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validate :valid_cpf

  has_one :establishment
  has_many :orders
  enum :role, { :admin => 2, :employee => 5 }
  after_initialize :set_default_role, :if => :new_record?

  private

  def set_default_role
    self.role ||= :admin
  end

  def valid_cpf
    unless CPF.valid?(cpf)
      errors.add(:cpf, 'não é válido')
    end
  end
         
end
