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
    total_sponsor = project.project_sponsors.where(level_id: level).count
  end

  def strip_url(url)
    url.sub(/^https?\:\/\//, '').sub(/^www./,'') rescue nil
  end

  def amount_converter(amount)
    if amount.to_i.to_s.length > 7
      number_to_currency(number_to_human(amount), precision: 3)
    else
      number_to_currency(amount, precision: 0)
    end
  end

  def amount_converter_field(amount)
    if amount.to_s.length > 7
      number_to_human(amount)
    else
      amount
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

  def percentage_sponsor(project)
    donation = Donation.where("project_id = ?", project.id)
    total_funded = 0.0
    donation.each do |d|
      total_funded = total_funded + d.amount.to_f
    end
    total_funded += project.project_sponsors.sum(:cost)
    percentage = (total_funded/project.goal.to_i).round(2) * 100
    return percentage
  end

  def totalsponsor(project)
    donation = Donation.where("project_id = ?", project.id)
    total_funded = 0.0
    donation.each do |d|
      total_funded = total_funded + d.amount.to_f
    end
    total_funded += project.project_sponsors.sum(:cost)
    return total_funded
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
    return ENV['STRIPE_PUB_KEY']
  end

  def project_sponsor_by_level(project)
    gold_sponsors, silver_sponsors, bronze_sponsors, platinum_sponsors = [], [], [], []
    project.project_sponsors.each do |sponsor|
      if sponsor.level_id.eql?(1)
        platinum_sponsors << sponsor
      elsif sponsor.level_id.eql?(2)
        gold_sponsors << sponsor
      elsif sponsor.level_id.eql?(3)
        silver_sponsors << sponsor
      elsif sponsor.level_id.eql?(4)
        bronze_sponsors << sponsor
      end
    end
    sponsors = {
      "PLATINUM" => platinum_sponsors,
      "GOLD" => gold_sponsors,
      "SILVER" => silver_sponsors,
      "BRONZE" => bronze_sponsors
    }
    sponsors
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

  def avatar_project_admin(avatar_link)
    avatar_link = "default-user.png" if avatar_link.eql?("/images/default-avatar.png")
    avatar_link
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
    if controller_name.eql?("users") and action_name.eql?("show")
      "display:none"
    else
      "display:block"
    end
  end

end
