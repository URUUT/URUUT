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
end
