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

end
