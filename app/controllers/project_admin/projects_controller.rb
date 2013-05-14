class ProjectAdmin::ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_project_ajax, except: [:index, :update, :show, :add_contact, :send_email]

  respond_to :js, except: [:index, :update, :show]
  layout false, :only => "stripe_update"

  def index
    @projects = Project.find(params[:id])
  end
  
  def show
    @project = Project.find(params[:id])
    @donations = Donation.find_all_by_project_id(@project.id)
    sponsors = ProjectSponsor.find_by_project_id(@project.id)
    @sponsor_count = sponsors.nil? ? 0 : sponsors.count
<<<<<<< HEAD
    logger.debug(@sponsor_count)
    logger.debug(@project)
    logger.debug(@donations)
  end

end
=======
  end

  def update
    asd
  end

  def messages; end

  def overview; end

  def manage; end

  def detail; end

  def visual; end

  def cover_photo_and_gallery; end

  def post_to_social_media; end

  def send_email
    @error_messages = []

    @error_messages << "email can't be blank" if params[:email_recepient].blank?
    @error_messages << "email header can't be blank" if params[:email_header].blank?
    @error_messages << "email content can't be blank" if params[:post]["email_content"].blank?

    if @error_messages.blank?
      ProjectMailer.project_message(params[:email_recepient], params[:email_header], params[:post]["email_content"]).deliver
    end
  end

  def emails_page
    @contact = Contact.new
  end

  def add_contact
    @email_exists = true

    if current_user.contacts.where(email: params[:email]).empty?
      @email_exists = false
      current_user.contacts.create(email: params[:email])
    end
  end

  private

  def set_project_ajax
    @project = Project.find(params[:project_id])
    session[:current_project] = @project.id
  end


end
>>>>>>> 76c236a... add tab page function
