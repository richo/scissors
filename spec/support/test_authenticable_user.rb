
class TestAuthenticableUser

  def self.find_by_identity(ident)
    ident == 'Jon' ? self.new : nil
  end

  def authenticate(password)
    password == 'irenicus'
  end

  def identity
    "Jonoleth Irenicus"
  end

  def allowed_to_use?(app)
    app == :myapp
  end

  def serialize_for_app(app)
    {:ident => identity, :app => app}
  end

  def can_terminate_sessions?
    false
  end
end

class TestAdminUser
  def can_terminate_sessions?
    true
  end
end
