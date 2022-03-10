class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  field :email, type: String
  field :password_digest, type: String 
  field :username, type: String
  field :role, type: String, default: 'user'
  has_secure_password
  
  def is_admin?
    return false unless role == 'admin'
  end

end
