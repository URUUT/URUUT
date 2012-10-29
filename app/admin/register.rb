ActiveAdmin.register_page "Register" do

  menu :priority => 1, :label => "Register"

  content :title => "Register" do
    # render 'devise/registrations/edit'
    render :template => 'devise/registrations/edit'
  end # content
end