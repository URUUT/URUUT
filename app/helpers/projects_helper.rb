module ProjectsHelper

	def time_left(endDate)
		newEndDate = Date.parse(endDate)
		today = Date.today
		timeLeft = newEndDate - today
		return timeLeft
	end

	def vidUrl(oldUrl)
		uri = URI(oldUrl)
		scheme = uri.scheme
		path = uri.path
		host = uri.host
		addition = 'embed'
		newUrl = scheme + '://www.youtube.com/' + addition + path
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
			'parks and recreation',
			'neighborhood',
			'cleanup/beautification',
			'roads and sidewalks',
			'health & well being',
			'child & adolescent',
			'pets',
			'miscellaneous'
		]
	end
end
