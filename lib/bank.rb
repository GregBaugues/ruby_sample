require_relative "credit_card"

#find better name
class Bank
	attr_reader :credit_cards

	#check out ruby 2.0 keyword arguments
	def initialize(options={})
		#refactor enumerable
		hash = Hash.new
		credit_cards = options[:credit_cards]
		if credit_cards
			credit_cards.each do |card|
				hash[card.cardholder] = card
			end
		end
		@credit_cards = hash
	end

	def add_card(card)
		@credit_cards[card.cardholder] = card
	end

	def charge_card(cardholder, dollars)
		card = @credit_cards[cardholder]
		card.valid? ? card.charge(dollars) : return
	end

	def credit_card(cardholder, dollars)
		card = @credit_cards[cardholder]
		card.valid? ? card.credit(dollars) : return
	end

	def to_json(options={})
		@credit_cards.values.to_json
	end

	def self.json_create(json)
		data = JSON.load(json)
		credit_cards = data.collect {|card| Credit_Card.hash_create(card)}
		self.new(:credit_cards => credit_cards)
	end
end