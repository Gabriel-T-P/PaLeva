class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :first_name, :last_name, :cpf, presence: true
  validates :cpf, uniqueness: true
  
  
  validate :valid_cpf

  private

  def valid_cpf
    unless CPF.valid?(cpf)
      errors.add(:cpf, "é inválido")
    end
  end      
         
end
