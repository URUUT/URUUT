module MailerHelper
	def make_currency(amount)
		number_to_currency(amount, :precision => 0)
	end
end