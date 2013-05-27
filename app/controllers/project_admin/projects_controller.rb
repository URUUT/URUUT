class ProjectAdmin::ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_project_ajax, except: [:index, :update, :show,
    :send_email, :email_based_on_sponsor_level]

  respond_to :js, except: [:index, :update, :show, :emails_page]
  layout false, :only => "stripe_update"

  def index
    @projects = Project.find(params[:id])
  end

  def show
    @project = Project.find(params[:id])
    subheader
  end

  def update

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
    @need_doctype = true
    level_ids = @project.project_sponsors.map(&:level_id).uniq
    @sponsorship_levels = SponsorshipLevel.where("id IN (?)", level_ids)

    subheader
  end

  def email_based_on_sponsor_level
    project = Project.find(session[:current_project])
    emails = project.project_sponsors.joins(:sponsor).where("level_id = ?", params[:level_id]).pluck(:email)
    emails.reject!(&:empty?)
    @emails = emails.join(",")
  end

  private

  def set_project_ajax
    @project = Project.find(params[:project_id])
    session[:current_project] = @project.id
  end

  def subheader
    @donations = Donation.find_all_by_project_id(@project.id)
    # sponsors = ProjectSponsor.find_by_project_id(@project.id)
    sponsors = ProjectSponsor.where(project_id: @project.id)
    @sponsor_count = sponsors.nil? ? 0 : sponsors.count
  end

end

