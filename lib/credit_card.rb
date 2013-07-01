require "json"

# Don't use underscores in class names. This should be CreditCard throughout
class Credit_Card
	attr_reader :cardholder, :cc_number, :balance, :limit

	def initialize(cardholder, credit_card_number, card_limit)

		#not obvious to me what the "" + accomplishes
		@cardholder = "" + cardholder.capitalize

		#doing the same thing with the 0 + ... not sure why.
		#ternaries get complicated and hard to read.
		# You're doing multiple things here - assignment and error reporting.
		# I'd stick to one per line, and use the if. It's not as sexy but it's more readable

		#credit_card_number >= 0 ? @cc_number = 0 + credit_card_number : raise("Negative credit card numbers not allowed")
		#card_limit >= 0 ? @limit = 0 + card_limit : raise("Negative card limits not allowed")

		if credit_card_number >= 0
			@cc_number = credit_card_number
		else
			raise("Negative credit card numbers not allowed")
		end

		if card_limit >= 0
			@limit = card_limit
		else
			raise("Negative card limits not allowed")
		end

		@balance = 0
	end

	def charge(dollars)
		#return is implied.
		# @balance + dollars <= limit ? @balance += dollars : return

		@balance += dollars if @balance + dollars <= limit
	end

	def credit(dollars)
		@balance -= dollars
	end

	def valid?
		# return is implied
		# return @cc_number.to_s.size <= 19 && Credit_Card.passes_luhn10(@cc_number)

		@cc_number.to_s.size <= 19 && Credit_Card.passes_luhn10(@cc_number)
	end

	# accepted way to define this is to use self.
	#def Credit_Card.passes_luhn10(credit_card_number)

	def self.passes_luhn10(credit_card_number)
		ccNumber = credit_card_number.to_s.split(//).collect { |digit| digit.to_i }
		parity = ccNumber.length % 2
	  sum = 0

	  ccNumber.each_with_index do |digit,index|
	    digit *= 2 if index % 2 == parity
	    digit -= 9 if digit > 9
	    sum += digit
	  end

  	# implied return (sum % 10) == 0
  	(sum % 10) == 0
	end

	#I'd move to multiple lines to make more readable
	def to_json(options={})
		{	'cardholder' => @cardholder,
			'cc_number' => @cc_number,
			'balance' => @balance,
			'limit' => @limit}.to_json
	end

	def self.json_create(json)
		data = JSON.load(json)
		return Credit_Card.hash_create(data)
	end

	def self.hash_create(hash)
		#use symbols instead of strings as hash keys (you'll need to change this when you pass in the argument too)
		#be consistent with self vs. CreditCard. I'd use self. when defining, CreditCard when invoking
		#card = self.new(hash['cardholder'], hash['cc_number'], hash['limit'])

		card = Credit_Card.new(hash[:cardholder], hash[:cc_number], hash[:limit])
		card.charge(hash[:balance])

		#don't explicitly say return. it's implied.
		card
	end
end