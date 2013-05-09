require "spec_helper"
require "bank"
require "credit_card"

describe Bank do
	let(:sample_bank) {
		Bank.new(:credit_cards => [
			Credit_Card.new('Valid', 4111111111111111, 1000),
			Credit_Card.new('Invalid', 1234567890123456, 2000)
			])
	}

	describe "#initialize" do
		it "instantiates properly" do
			bank = Bank.new(:credit_cards => [Credit_Card.new('Tom', 4111111111111111, 1000)])
			bank.credit_cards['Tom'].limit.should == 1000
		end
		it "instantiates without credit_cards" do
			bank = Bank.new
			bank.credit_cards.should_not be_nil
		end
	end

	describe "#add_card" do
		it "adds a card" do
			sample_bank.add_card(Credit_Card.new('Lisa', 5454545454545454, 3000))
			sample_bank.credit_cards['Lisa'].limit.should == 3000
		end
		it "overwrites existing cards" do
			sample_bank.add_card(Credit_Card.new('Lisa', 5454545454545454, 3000))
			sample_bank.add_card(Credit_Card.new('Lisa', 5454545454545454, 5000))
			sample_bank.credit_cards['Lisa'].limit.should == 5000
		end
	end

	describe "#charge_card" do
		it "charges a valid card" do
			sample_bank.charge_card('Valid', 500)
			sample_bank.credit_cards['Valid'].balance.should == 500
		end
		it "does not charge an invalid card" do
			sample_bank.charge_card('Invalid', 200)
			sample_bank.credit_cards['Invalid'].balance.should == 0
		end
		it "raises an error for a non-existent card" do
			expect{sample_bank.charge_card('fjeiawof', 200)}.to raise_error
		end
	end

	describe "#credit_card" do
		it "credits a valid card" do
			sample_bank.credit_card('Valid', 500)
			sample_bank.credit_cards['Valid'].balance.should == -500
		end
		it "does not credit an invalid card" do
			sample_bank.credit_card('Invalid', 500)
			sample_bank.credit_cards['Invalid'].balance.should == 0
		end
		it "raises an error for a non-existent card" do
			expect{sample_bank.credit_card('fjeiawof', 200)}.to raise_error
		end
	end

	describe "#to_json" do
		it "generates the right json output" do
			sample_bank.to_json.should == "[{\"cardholder\":\"Valid\",\"cc_number\":4111111111111111,\"balance\":0,\"limit\":1000},{\"cardholder\":\"Invalid\",\"cc_number\":1234567890123456,\"balance\":0,\"limit\":2000}]"
		end
	end

	describe ".json_create" do
		it "creates a bank from json" do
			json = "[{\"cardholder\":\"Valid\",\"cc_number\":4111111111111111,\"balance\":0,\"limit\":1000},{\"cardholder\":\"Invalid\",\"cc_number\":1234567890123456,\"balance\":0,\"limit\":2000}]"
			s_bank = Bank.json_create(json)
			s_bank.credit_cards['Valid'].should be_valid
			s_bank.credit_cards['Invalid'].limit.should == 2000
		end
	end

	context "complex use case" do
		it "passes" do
			sample_bank.charge_card('Invalid', 200)
			sample_bank.credit_cards['Invalid'].balance.should == 0
			sample_bank.add_card(Credit_Card.new('Invalid', 0, 2000))
			sample_bank.charge_card('Invalid', 200)
			sample_bank.credit_cards['Invalid'].balance.should == 200
		end
	end

end