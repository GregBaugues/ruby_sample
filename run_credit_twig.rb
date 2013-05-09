#!/usr/bin/env ruby
require_relative "lib/credit_twig"

#not sure how to test main methods
if __FILE__ == $PROGRAM_NAME
	ct = Credit_Twig.new
	data_filename = 'lib/data.json'
	ct.load_json(data_filename) if File.exists?(data_filename)
	if ARGV[0]
		ct.load_args(ARGV[0])
		ct.summary
		ct.save_json(data_filename)
	else
		puts "\nWelcome to Credit Twig!\n\nYour commands are:\nAdd (Name) (Credit Card Number) (Card Limit)\nCharge (Name) (Amount in Dollars)\nCredit (Name) (Amount in Dollars)\n\n"
		if File.exists?(data_filename)
			puts "Current cards:\n"
			ct.summary
		end
		begin
			while true
				user_input = gets.chomp
				ct.parse_arg(user_input)
				ct.summary
			end
		rescue Interrupt
			ct.save_json(data_filename)
			puts "\nTerminating...."
		end
	end
end