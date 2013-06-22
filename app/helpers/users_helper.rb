module UsersHelper
	def us_states
	    [
	      ['AL'],
	      ['AK'],
	      ['AZ'],
	      ['AR'],
	      ['CA'],
	      ['CO'],
	      ['CT'],
	      ['DE'],
	      ['DC'],
	      ['FL'],
	      ['GA'],
	      ['HI'],
	      ['ID'],
	      ['IL'],
	      ['IN'],
	      ['IA'],
	      ['KS'],
	      ['KY'],
	      ['LA'],
	      ['ME'],
	      ['MD'],
	      ['MA'],
	      ['MI'],
	      ['MN'],
	      ['MS'],
	      ['MO'],
	      ['MT'],
	      ['NE'],
	      ['NV'],
	      ['NH'],
	      ['NJ'],
	      ['NM'],
	      ['NY'],
	      ['NC'],
	      ['ND'],
	      ['OH'],
	      ['OK'],
	      ['OR'],
	      ['PA'],
	      ['PR'],
	      ['RI'],
	      ['SC'],
	      ['SD'],
	      ['TN'],
	      ['TX'],
	      ['UT'],
	      ['VT'],
	      ['VA'],
	      ['WA'],
	      ['WV'],
	      ['WI'],
	      ['WY']
	    ]
	end

	def project_length
	    [
        [30],
        [45],
        [60],
        [75],
        [90]
	    ]
  end

  # Helper method for I - They on User profile page
  # @param type
  # :who - I, they
  # :whose - my, their
  def who(type = :who)
    if @is_current
      if type == :who
        "I"
      else
        "My"
      end
    else
      if type == :who
        "They"
      else
        "Their"
      end
    end
  end

end
