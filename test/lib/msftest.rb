## This class consists of assert helper methods for regexing logs
##
## $Id$

$:.unshift(File.expand_path(File.dirname(__FILE__)))

require 'regexr'
require 'test/unit'

class MsfTestCase < Test::Unit::TestCase

	def assert_complete(data,first,last)
		@regexr = Regexr.new(true)
		assert_not_nil @regexr.verify_start(data,first), "The start string " + data.split("\n").first + " did not match the expected string: " + first
		assert_not_nil @regexr.verify_end(data,last), "The end string " + data.split("\n").last + " did not match the expected string: " + last
	end

	def assert_all_successes(data, regex_strings)
		@regexr = Regexr.new(true)
		if regex_strings
			regex_strings.each { |regex_string|
				puts "Making sure " + regex_string + " is included."
				assert_true @regexr.ensure_exists_in_data(data,regex_string), "The string " + regex_string + " was not found in the data."
			}
		end
	end
	
	def scan_for_errors(data)
		scan_for_failures(data,['exception'],[])
	end 
	
	def assert_no_failures(data, regex_strings, exception_strings)
		@regexr = Regexr.new(true)
		if regex_strings
			regex_strings.each { |regex_string|
				puts "Making sure " + regex_string + " isn't included."
				assert_true @regexr.ensure_doesnt_exist_in_data_unless(data,regex_string,exception_strings), "The string " + regex_string + " was found in the the data, and no exception was found."
			}
		end
	end
end
