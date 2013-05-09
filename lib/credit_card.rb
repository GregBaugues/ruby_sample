require "json"

class Credit_Card
	attr_reader :cardholder, :cc_number, :balance, :limit

	def initialize(cardholder, credit_card_number, card_limit)
		@cardholder = "" + cardholder.capitalize
		credit_card_number >= 0 ? @cc_number = 0 + credit_card_number : raise("Negative credit card numbers not allowed")
		card_limit >= 0 ? @limit = 0 + card_limit : raise("Negative card limits not allowed")
		@balance = 0
	end
	
	def charge(dollars)
		@balance + dollars <= limit ? @balance += dollars : return
	end

	def credit(dollars)
		@balance -= dollars
	end

	def valid?
		return @cc_number.to_s.size <= 19 && Credit_Card.passes_luhn10(@cc_number)
	end

	def Credit_Card.passes_luhn10(credit_card_number)
		ccNumber = credit_card_number.to_s.split(//).collect { |digit| digit.to_i }
		parity = ccNumber.length % 2
	  sum = 0

	  ccNumber.each_with_index do |digit,index|
	    digit *= 2 if index % 2 == parity
	    digit -= 9 if digit > 9
	    sum += digit
	  end

  	return (sum % 10) == 0
	end

	def to_json(options={})
		{'cardholder' => @cardholder, 'cc_number' => @cc_number, 'balance' => @balance, 'limit' => @limit}.to_json
	end

	def self.json_create(json)
		data = JSON.load(json)
		return Credit_Card.hash_create(data)
	end

	def self.hash_create(hash)
		card = self.new(hash['cardholder'], hash['cc_number'], hash['limit'])
		card.charge(hash['balance'])
		return card
	end
end