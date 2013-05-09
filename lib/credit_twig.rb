require_relative "bank"
require_relative "credit_card"

class Credit_Twig 
	attr_accessor :bank

	def initialize(options={})	
		options[:bank] ? @bank = options[:bank] : @bank = Bank.new
	end

	def add(cardholder, credit_card_number, limit)
		@bank.add_card(Credit_Card.new(cardholder, credit_card_number, limit))
	end

	def charge(cardholder, dollars)
		@bank.charge_card(cardholder, dollars)
	end

	def credit(cardholder, dollars)
		@bank.credit_card(cardholder, dollars)
	end

	def parse_arg(arg)
		arguments = arg.split
		case arguments.first
		when 'Add'
			add(arguments[1], arguments[2].to_i, arguments[3].split('$').last.to_i)
		when 'Charge'
			charge(arguments[1], arguments[2].split('$').last.to_i)
		when 'Credit'
			credit(arguments[1], arguments[2].split('$').last.to_i)
		else
			puts "Invalid input"
		end
	end	

	def load_args(file)
		file = File.open(file, 'r')
		file.each_line do |line|
			parse_arg(line)
		end
	end

	def load_json(json_file)
		@bank = Bank.json_create(IO.read(json_file))
	end

	def save_json(filename)
		if @bank.credit_cards.values.size > 0
			File.open(filename, 'w+') do |f|
				f.write(@bank.to_json)
			end
		else
			return
		end
	end

	def summary
		sorted_cards = @bank.credit_cards.values.sort {|x, y| x.cardholder <=> y.cardholder}
		sorted_cards.each do |card|
			card.valid? ? puts("#{card.cardholder}: $#{card.balance}") : puts("#{card.cardholder}: error")
		end
	end

end


