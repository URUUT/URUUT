module ProjectsHelper

	def time_left(endDate, startDate)
    endDate = Date.parse(startDate) + endDate.to_i.days
    finalDate = endDate - Date.today
    return finalDate.to_i    
	end

	def vidUrl(oldUrl)
		uri = URI(oldUrl)
		scheme = uri.scheme
		path = uri.path
		host = uri.host
		addition = 'embed'
		newUrl = '#{scheme}://www.youtube.com/#{addition}#{path}'
		return newUrl
	end

	def project_title(id)
		project = Project.find(id)
		return project.title
	end

	def current_project
		session[:current_project]
	end

	def project_categories
		[
			#['parks & recreation','parks & recreation'],
			#['neighborhood','neighborhood'],
			#['cleanup/beautification','cleanup & beautification'],
			#['roads & sidewalks','roads & sidewalks'],
			#['health & well being','health & well being'],
			#['child & adolescent','child & adolescent'],
			#['pets','pets'],
			#['miscellaneous','miscellaneous']
      #['Animal / Pets],
      ['Art / Culture'],
      ['Athletic / Sports'],
      ['Education / Schools'],
      ['Health / Wellness'],
      ['Local Business'],
      ['Neighborhood Improvements'],
      ['Parks & Recreation'],
      ['Safety'],
      ['Sustainability / Energy'],
      ['Technology'],
      ['Transit / Transportation'],
      ['Walkability / Bike / Paths']
		]
	end

  def project_duration(duration)
    if !duration.nil?
      Time.parse(duration).strftime("%m/%d/%y")
    end
  end

  def stored_content
    content_for :description do
      "This is some text"
    end
  end

end
