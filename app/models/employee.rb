class Employee < User
  after_initialize :set_default_role_and_status, :if => :new_record?

  private

  def set_default_role_and_status
    self.role = :employee
    self.status = :pre_registered
  end

  def password_required?
    !pre_registered? && (password.present? || password_confirmation.present?)
  end  

end