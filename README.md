# Credit Twig

### Preparing for Credit Twig

If you want to make use of guard, install the gems from the Gemfile:

`bundle install`

(Note that the ruby version I'm using is 1.9.3p362)

### Using Credit Twig

While using the command line in the top directory (credit_twig/), you have 2 options.

1.	Use a file as input, in which case:

	`ruby run_credit_twig.rb path_for_file_input`

	OR

2.	Run the program as a makeshift command-line utility:

	`ruby run_credit_twig.rb`

	And to exit, press ctrl+c (or whatever else kills the current process)

### Notes

If you "add" two cards with the same cardholder name, it will simply overwrite the previously stored cardholder with the new card, limit, and empty balance. Read the 'Use Case Concerns' to find out more.

Any cards you add, charge, or credit will be saved in a file called *data.json* in the lib/ directory. Delete this file if you would like to start from scratch.

All of the tests, written in RSpec, are in the spec/lib directory. 3 tests are pending because they are dealing with I/O, and I wasn't sure how to meaningfully test them.
