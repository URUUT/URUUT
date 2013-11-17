require 'spec_helper'

describe User do

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:remember_me) }
  it { should respond_to(:city) } 
  it { should respond_to(:state) } 
  it { should respond_to(:zip) }
  it { should respond_to(:neighborhood) } 
  it { should respond_to(:provider) } 
  it { should respond_to(:role) } 
  it { should respond_to(:uid) } 
  it { should respond_to(:token) } 
  it { should respond_to(:organization) } 
  it { should respond_to(:mission) } 
  it { should respond_to(:subscribed) } 
  it { should respond_to(:avatar) } 
  it { should respond_to(:uruut_point) }
end
