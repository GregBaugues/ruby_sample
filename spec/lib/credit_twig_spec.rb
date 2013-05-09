require "spec_helper"
require "credit_twig"
require "bank"

describe Credit_Twig do 
	let(:sample_ct) {Credit_Twig.new(
			:bank => Bank.new(:credit_cards => [
				Credit_Card.new('Valid', 4111111111111111, 1000),
				Credit_Card.new('Invalid', 1234567890123456, 2000)
				])
		)}

	describe "#initialize" do
		it "instantiates properly" do
			ct = Credit_Twig.new(:bank => Bank.new)
			ct.bank.should_not be_nil
		end
	end

	describe "#add" do
		it "calls #add_card on @bank" do
			sample_ct.bank.should_receive(:add_card)
			sample_ct.add('Tom', 0, 1000)
		end
	end

	describe "#charge" do
		it "calls #charge_card on @bank" do
			sample_ct.bank.should_receive(:charge_card).with('Valid', 500)
			sample_ct.charge('Valid', 500)
		end
	end

	describe "#credit" do
		it "calls #credit_card on @bank" do
			sample_ct.bank.should_receive(:credit_card).with('Valid', 500)
			sample_ct.credit('Valid', 500)
		end
	end

	describe '#parse_arg' do
		it "calls #add" do
			sample_ct.should_receive(:add).with('Tom', 4111111111111111, 1000)
			sample_ct.parse_arg('Add Tom 4111111111111111 $1000')
		end
		it "calls #charge" do
			sample_ct.should_receive(:charge).with('Tom', 500)
			sample_ct.parse_arg('Charge Tom $500')
		end
		it "calls #credit" do
			sample_ct.should_receive(:credit).with('Tom', 800)
			sample_ct.parse_arg('Credit Tom $800')
		end
		it "puts 'Invalid input' if the input is invalid" do
			STDOUT.should_receive(:puts).with("Invalid input")
			sample_ct.parse_arg('cljiafoe')
		end
	end
	#not sure how to meaningfully test file I/O
	describe "#load_args" do
		it "opens a file" do
			# File.should_receive(:open).with('file', 'r')
			# sample_ct.load_file('file')
		end
		it "calls #parse_arg on each line" do
			# sample_ct.should_receive(:add).with('Tom', 4111111111111111, 1000)
			# sample_ct.should_receive(:charge).with('Tom', 500)
			# sample_ct.should_receive(:credit).with('Tom', 800)
			# STDOUT.should_receive(:puts).with("Invalid input")
			# sample_ct.load_file("
			# 	Add Tom 4111111111111111 $1000\n
			# 	Charge Tom $500\n
			# 	Credit Tom $800\n
			# 	fjeawofjaewi\n
			# 	")
		end
	end

	describe "#load_json" do
		it "loads the .json file"
	end

	describe "#save_json" do
		it "saves bank data in a .json file"
	end

	describe "#summary" do
		it "prints a summary report of the bank" do
			STDOUT.should_receive(:puts).with("Valid: $0")
			STDOUT.should_receive(:puts).with("Invalid: error")
			sample_ct.summary
		end
		it "prints a summary that's sorted by cardholder"
	end


end

