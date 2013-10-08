class ProjectAdmin::ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_project, only: :show
  before_filter :set_project_ajax, except: [:index, :update, :show,
    :send_email, :email_based_on_sponsor_level, :project_update, :process_project_update]

  respond_to :js, except: [:index, :update, :show, :emails_page, :messages]
  has_scope :page, :default => 1
  layout false, :only => "stripe_update"

  def index
    @projects = Project.find(params[:id])
  end

  def show
    subheader
    @fundings = @project.all_funding_by_project(params[:page])
    @total_fundings = @project.total_funding_by_project

    respond_to do |format|
      format.js
      format.html
    end
  end

  def messages
    subheader
    @fundings = @project.all_funding_by_project(params[:page])
    @total_fundings = @project.total_funding_by_project

    respond_to do |format|
      format.js
      format.html
    end
  end

  def overview; end

  def manage
    @galleries = @project.galleries.page(params[:page]).per(6)
  end

  def detail; end

  def visual; end

  def project_update
    @project_update = ProjectUpdate.new
    session[:current_project] = params[:project_id]
  end

  def process_project_update
    params[:project_update][:project_id] = session[:current_project]
    project_update = ProjectUpdate.new(params[:project_update])
    project_update.save
    @alert = "Project successfully updated"
  end

  def cover_photo_and_gallery
    @galleries = @project.galleries.page(params[:page]).per(6)
  end

  def post_to_social_media; end

  def project_founder
    @project = Project.find(params[:project_id])

    if params[:type].blank?
      @founders = @project.founders(params[:page])
      @all = true
    else
      @founders = if params[:type].eql?("individual")
        @project.individual_donors(params[:page])
      else
        @project.project_sponsor_by_level(params[:page])
      end
      @all = false
    end
  end

  def send_email
    @error_messages = []

    @error_messages << "email recipient can't be blank" if params[:email_recepient].blank?
    @error_messages << "email subject can't be blank" if params[:post]["subject"].blank?
    @error_messages << "email content can't be blank" if params[:post]["email_content"].blank?

    if @error_messages.blank?
      subject = params[:post][:subject]
      recepients = params[:email_recepient].split(",")
      recepients.each do |recepient|
        ProjectMailer.project_message(recepient, params[:post]["subject"], params[:email_header], params[:post]["email_content"]).deliver
      end
    end
  end

  def emails_page
    @project = Project.find(params[:project_id])
    @total_fundings = @project.total_funding_by_project
    @contact = Contact.new
    @need_doctype = true
    @list_recepients = @project.list_recepient

    subheader
  end

  def email_based_on_sponsor_level
    project = Project.find(session[:current_project])
    case params[:level_id]
    when "All Project Sponsors and Donors"
      emails_sponsor = project.project_sponsors.joins(:sponsor).pluck(:email).uniq
      emails_donors = project.donations.where(anonymous: false).pluck(:email).uniq
      emails = emails_donors + emails_sponsor
    when "All Project Sponsors"
      emails = project.project_sponsors.joins(:sponsor).pluck(:email).uniq
    when "All Project Donors"
      emails = project.donations.where(anonymous: false).pluck(:email).uniq
    when "My Contacts"
      emails = []
    else
      if params[:level_id].to_i.to_s == params[:level_id]
        emails = project.project_sponsors.joins(:sponsor).where("level_id = ?", params[:level_id]).uniq.pluck(:email)
      else
        level_name = params[:level_id].split(" Project")
        emails = project.donations.where(anonymous: false).where("perk_name = ?", level_name[0]).uniq.pluck(:email)
      end
    end

    emails.reject!(&:empty?)
    @emails = emails.join(",")
  end

  def photos_and_videos
    @photos_and_videos = @project.galleries.media_transparent_room(params[:page])
  end

  def communication_zone
    @test = "test"
    respond_to do |format|
      format.js
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
    admin_required!
  end

  def set_project_ajax
    @project = Project.find(params[:project_id])
    session[:current_project] = @project.id
    admin_required!
  end

  def subheader
    @donations = Donation.find_all_by_project_id(@project.id)
    @sponsors = ProjectSponsor.where(project_id: @project.id)
    @sponsor_count = @sponsors.empty? ? 0 : @sponsors.count
  end

  def admin_required!
     unless current_user.is_admin?
      unless @project.user.id.eql?(current_user.id)
       flash[:error] = "Sorry, you don't have right permision to accessing page."
       redirect_to root_url and return false
      end
     end
  end

end
