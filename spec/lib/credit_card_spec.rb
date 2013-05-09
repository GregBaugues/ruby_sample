require "spec_helper"
require "credit_card"

describe Credit_Card do 
	let(:valid_card) {Credit_Card.new('Tom', 4111111111111111, 1000)}
	let(:invalid_card) {Credit_Card.new('Quincy', 1234567890123456, 2000)}

	describe "#initialize" do
		it "initializes properly" do
			card = Credit_Card.new('Bob', 5, 3000)
			card.cardholder.should == 'Bob'
			card.cc_number.should == 5
			card.limit.should == 3000
			card.balance.should == 0
		end
		it "does not initialize without arguments" do
			expect{Credit_Card.new}.to raise_error
		end
		it "ducktype-checks its attributes" do
			expect{Credit_Card.new(4, 1, 2)}.to raise_error
			expect{Credit_Card.new('Bob', "", 2)}.to raise_error
			expect{Credit_Card.new(4, 1, 7.0)}.to raise_error
		end
		it "raises an error for negative limits" do
			expect{Credit_Card.new('Bob', 1, -1)}.to raise_error
		end
		it "raises an error for negative credit card numbers" do
			expect{Credit_Card.new('Bob', -1, 10)}.to raise_error
		end
	end

	describe "#charge" do
		it "increments the balance" do
			valid_card.charge(500)
			valid_card.balance.should == 500
		end
		context "card is charged past it's limit" do
			it "does nothing" do
				valid_card.charge(3001)
				valid_card.balance.should == 0
			end
		end
	end

	describe "#credit" do
		it "decrements the balance to negatives" do
			valid_card.credit(10)
			valid_card.balance.should == -10
		end
	end

	context "#charge and #credit" do
		it "do arithmetic properly" do
			valid_card.charge(20)
			valid_card.credit(10)
			valid_card.balance.should == 10
		end
	end

	describe "#valid?" do
		it "invalidates numbers longer than 19 digits" do
			card = Credit_Card.new('Bob', 41111111111111111115, 3000)
			Credit_Card.passes_luhn10(card.cc_number).should be_true
			card.should_not be_valid
		end
		it "validates numbers using Luhn 10" do
			valid_card.should be_valid
			invalid_card.should_not be_valid
		end
	end

	describe ".passes_luhn10" do
		context "if cc_number is 0" do
			it "returns true" do
				zero_card = Credit_Card.new('Bob', 0, 3000)
				Credit_Card.passes_luhn10(zero_card.cc_number).should be_true
			end
		end
		context "if cc_number is valid" do
			it "returns true" do
				Credit_Card.passes_luhn10(valid_card.cc_number).should be_true
			end
		end
		context "if cc_number is not valid" do
			it "returns false" do
				Credit_Card.passes_luhn10(invalid_card.cc_number).should be_false
			end
		end
	end

	describe "#to_json" do
		it "generates the right json output" do
			valid_card.to_json.should == "{\"cardholder\":\"Tom\",\"cc_number\":4111111111111111,\"balance\":0,\"limit\":1000}"
		end
	end

	describe ".json_create" do
		it "creates a card from json" do
			json = "{\"cardholder\":\"Tom\",\"cc_number\":4111111111111111,\"balance\":500,\"limit\":1000}"
			card = Credit_Card.json_create(json)
			card.balance.should == 500
			card.cardholder.should == "Tom"
			card.cc_number.should == 4111111111111111
			card.limit.should == 1000
		end
	end

	describe ".hash_create" do
		it "creates a card from a hash" do
			hash = {"cardholder"=>"Tom", "cc_number"=>4111111111111111, "balance"=>2, "limit"=>1000}
			card = Credit_Card.hash_create(hash)
			card.balance.should == 2
			card.cardholder.should == 'Tom'
			card.cc_number.should == 4111111111111111
			card.limit.should == 1000
		end
	end	

end