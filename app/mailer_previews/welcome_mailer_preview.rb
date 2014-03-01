class WelcomeMailerPreview
  def welcome_confirmation_donor
    WelcomeMailer.welcome_confirmation_donor mock_user
  end


  def welcome_confirmation_user
    WelcomeMailer.welcome_confirmation_user mock_user
  end

  def mock_user(first_name='Bill', last_name='Gates')
    fake_id User.new(first_name: first_name, last_name: last_name, email: "user#{rand 100}@test.com")
  end

  def fake_id(obj)
    # overrides the method on just this object
    obj.define_singleton_method(:id) { 123 + rand(100) }
    obj
  end

end
