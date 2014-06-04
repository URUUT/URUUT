require 'stripe'

module ApplicationHelper

	def current_project
		session[:current_project]
	end

  def recognize_url(url)
    if url.nil?
      nil
    else
      if url.include?("http://") or url.include?("https://")
        url
      else
        "http://#{url}"
      end
    end
  end

  def check_availibility(project, level)
    project.project_sponsors.where(level_id: level).count
  end

  def strip_url(url)
    url.sub(/^https?\:\/\//, '').sub(/^www./,'') rescue nil
  end

  def amount_converter(amount)
    if amount.to_f.to_s.length > 9
      number_to_currency(number_to_human(amount, precision: 2))
    else
      number_to_currency(amount, precision: 0)
    end
  end

  def amount_converter_field(amount)
    if amount.to_s.length > 9
      number_to_currency(number_to_human(amount, precision: 3))
    else
      number_to_currency(amount, precision: 0)
    end
  end

  def percent_funded(id)
    project = Project.find(id)
    donation = Donation.where("project_id = ?", id)
    total_funded = 0.0
    donation.each do |d|
     total_funded = total_funded + d.amount.to_f
   end
   project_goal = project.goal.to_s.gsub(/,/, '').to_f

   percentage = total_funded/project_goal

   return percentage.round(2) * 100
		# return total_funded
		# return percentage
		# return total_funded
	end

  def amount_funded(id)
    project = Project.find(id)
    donation = Donation.where("project_id = ?", id)
    total_funded = 0.0
    donation.each do |d|
     total_funded = total_funded + d.amount.to_f
   end
		# percentage = total_funded/project.goal

		# return percentage.round(2) * 100
		return total_funded
		# return percentage
		# return total_funded
	end

	def get_user(id)
		user = User.find_by_id(id)
		return user.name
	end

	def get_gravatar(email, size)
		digest = Digest::MD5.hexdigest(email)
		return "http://www.gravatar.com/avatar/" + digest + ".jpg?s=#{size}"
	end

  def clean_data(data)
    clean = data.html_safe
    return clean
  end

  def get_currency(amount)
    amount = amount.to_s.gsub(/,/, '').to_f
    number_to_currency(amount, :precision => 0)
  end

  def stripe_pub_key
    return "pk_test_1XvbGBUir6OeX1ljhENDmZ7h"
  end

  def project_sponsor_by_level(founders, page_num, project)
    if page_num.nil?
      gold_sponsors, silver_sponsors, bronze_sponsors, platinum_sponsors = [], [], [], []
      founders.each do |sponsor|
        if sponsor.sponsorship_level.parent_id.eql?(1)
          platinum_sponsors << sponsor
        elsif sponsor.sponsorship_level.parent_id.eql?(2)
          gold_sponsors << sponsor
        elsif sponsor.sponsorship_level.parent_id.eql?(3)
          silver_sponsors << sponsor
        elsif sponsor.sponsorship_level.parent_id.eql?(4)
          bronze_sponsors << sponsor
        end
      end
      levels = SponsorshipLevel.by_project(project)
      sponsors = {}
      levels_sponsors = { "1" => platinum_sponsors,
                          "2" => gold_sponsors,
                          "3" => silver_sponsors,
                          "4" => bronze_sponsors }
      levels.each do |level|
        sponsors[level.name.upcase] = levels_sponsors[level.parent_id.to_s]
      end
    else
      bronze_sponsors = []
      founders.each do |sponsor|
        bronze_sponsors << sponsor
      end
      sponsors = { "BRONZE" => bronze_sponsors }
    end
    sponsors
  end

  def count_project_sponsor_by_level(sponsors, project)
    if sponsors.blank?
      0
    else
      id_level = sponsors.first.level_id
      ProjectSponsor.where(level_id: id_level, project_id: project.id).count
    end
  end

  def count_percentage(total, amount)
    total_precentage = if total.to_i.eql?(0) and amount.to_i.eql?(0)
      0
    else
      percentage = amount.to_f / total.to_f * 100.0
      percentage.to_s[0..3]
    end
    return "#{total_precentage} %"
  end

  def wizard_link(step, project)
    if step.eql?("sponsor_info")
      "/projects/#{project.id}/edit#sponsor-info"
    elsif step.eql?("project_details")
      if ["first", "second", "third", "fourth", "last"].include? session[:step]
        "/projects/#{project.id}/edit#project-details"
      else
        "javascript:void(0)"
      end
    elsif step.eql?("perks")
      if ["second", "third", "fourth", "last"].include? session[:step]
        "/projects/#{project.id}/edit#perks"
      else
        "javascript:void(0)"
      end
    elsif step.eql?("sponsorship")
      if ["third", "fourth", "last"].include? session[:step]
        "/projects/#{project.id}/edit#sponsorship"
      else
        "javascript:void(0)"
      end
    elsif step.eql?("assets")
      if ["fourth", "last"].include? session[:step]
        "/projects/#{project.id}/edit#assets"
      else
        "javascript:void(0)"
      end
    end
  end

  def total_amount_by_donor(donations)
    donations.map { |donation| donation.amount }.inject(0) {|sum, element| sum + element }
  end

  def total_donor_by_level(perk_name, project)
    Donation.where(perk_name: perk_name, project_id: project.id).group_by { |donation| donation.user_id }.count
  end

  def avatar_project_admin(avatar_link, anonymous)
    if anonymous
      avatar_link = "anonymous.png"
    else
      avatar_link = "default-user.png" if avatar_link.eql?("/images/default-avatar.png")
    end
    avatar_link
  end

  def donor_name_project_admin(name, anonymous)
    name = "Anonymous Donor" if anonymous
    name
  end

  def get_interval_chart(project)
    interval = project.duration.to_i < 45 ? 1 : 5
  end

  def show_td_mark(project)
    if project.organization_classification.eql?("170(c)(1)") || project.organization_classification.eql?("501(c)(3)")
      "display: block"
    else
      "display:none"
    end
  end

  def message_style(controller_name, action_name)
    if ( controller_name.eql?("users") and action_name.eql?("show") ) or ( controller_name.eql?("users") and action_name.eql?("profile") )
      "display:none"
    else
      "display:block"
    end
  end

  def document_thumbnail(url, width)
    "http://docs.google.com/viewer?url=#{url}&a=bi&pagenumber=1&w=#{width}"
  end

  def full_name user
    return "- #{user.first_name} #{user.last_name}"
  end

  def editable_level?(user, project)
    user.has_plan?('plus') && !project.is_live?
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def can_use_coupon?(user)
    return true unless user.coupon_stripe_token
    coupon = Stripe::Coupon.retrieve(user.coupon_stripe_token)
    ! coupon.valid
  end

  def upgrade_plan?(user, plan_id)
    return false if user.membership_kind == plan_id
    if (user.membership_kind == 'basic' && plan_id == 'plus') ||
       (user.membership_kind == 'fee' && (plan_id == 'basic' || plan_id == 'plus') )
      return true
    end
  end

end
