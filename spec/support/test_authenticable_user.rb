
class TestAuthenticableUser
  VALID_USER = "Jonoleth Irenicus".freeze
  VALID_PASSWORD = 'irenicus'.freeze

  def self.find_by_identity(ident)
    ident == VALID_USER ? self.new : nil
  end

  def authenticate(password)
    password == VALID_PASSWORD
  end

  def identity
    VALID_USER
  end

  def serialize_for_app(app)
    {:ident => identity, :random_other => 'property'}
  end

end
