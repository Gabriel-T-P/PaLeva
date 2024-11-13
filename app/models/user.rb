class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :first_name, :last_name, :password, presence: true, unless: :pre_registered?
  validates :cpf, uniqueness: true
  validate :valid_cpf

  belongs_to :establishment, optional: true
  has_many :orders
  
  enum :role, { :admin => 2, :employee => 5 }
  enum :status, { :pre_registered => 2, :active => 5 }, default: :active
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
