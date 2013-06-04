module ApplicationHelper

	def current_project
		session[:current_project]
	end

  def recognize_url(url)
    if url.include?("http://") or url.include?("https://")
      url
    else
      "http://#{url}"
    end
  end

  def check_availibility(project, level)
    total_sponsor = project.project_sponsors.where(level_id: level).count
  end

  def strip_url(url)
    url.sub(/^https?\:\/\//, '').sub(/^www./,'')
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
    percentage = amount.to_f / total.to_f * 100.0
    return "#{percentage.to_s[0..3]} %"
  end

  def wizard_link(step, project)
    if step.eql?("sponsor_info")
      if session[:step].eql?("first")
        "/projects/#{project.id}/edit#sponsor-info"
      else
        "javascript:void(0)"
      end
    elsif step.eql?("project_details")
      if session[:step].eql?("second") or session[:step].eql?("first")
        "/projects/#{project.id}/edit#project-details"
      else
        "javascript:void(0)"
      end
    elsif step.eql?("perks")
      if session[:step].eql?("third") or session[:step].eql?("second")
        "/projects/#{project.id}/edit#perks"
      else
        "javascript:void(0)"
      end
    elsif step.eql?("sponsorship")
      if session[:step].eql?("fourth") or session[:step].eql?("third")
        "/projects/#{project.id}/edit#sponsorship"
      else
        "javascript:void(0)"
      end
    elsif step.eql?("assets")
      if session[:step].eql?("last") or session[:step].eql?("fourth")
        "/projects/#{project.id}/edit#assets"
      else
        "javascript:void(0)"
      end
    end
  end

end
