#!/usr/bin/env devjython

# --> Question: Is there a Python and/or Broad standard for
# file comments? 

# ***************************
# Script to interactively run HQL statements 
# against the specified database, and print out 
# the (first 10) results.
# (Kind of like if you were running an interactive
# SQL command-line tool.)
#
# Uses the rlwrap utility to call devjython to execute
# this script, which means a couple things:
# 	1> You must have devjython in your path
#	2> You're sharing command-line history between
#	   this interpreter and devjython. (I can't 
#	   decide if that's a bug or a feature.)
#
# 2011-07+05 mhansen
# ***************************

import sys
import util
import java.lang as lang

# ***************************
# Usage
def usage ():
	print "usage: %s [test|prod]" % sys.argv[0]
	# Quitting out of jython here; if I just
	# used "sys.exit()" it would print a Java
	# stacktrace when exiting, so using Java's
	# System.exit instead. 
	# --> Question: Is there a better way to do this?
	lang.System.exit(0)

# ***************************
# Constants

# --> Question: Is there a canonical way of
# representing constants (e.g. "final static" or a 
# dedicated "constants" class)?

# Don't print out more than this many records
MAX_RESULTS = 10 

# ***************************
# Main

# --> Question: Do people tend towards object-orientation
# in Python scripts like this? Like for instance would they
# create a main class and instantiate it and what-not, or just 
# dive right into executing things like I'm doing here?

# --> Question: Is there a canonical way of parsing command-line args?

# Process command line argument -- only options
# are "test" and "prod".
if len(sys.argv) != 2 or (sys.argv[1] != "test" and sys.argv[1] != "prod"):
	usage()

# Expand the abbreviated, easier-to-type "prod" option 
# into the actual database name, "production"
database = sys.argv[1]
if database == "prod": 
	database = "production"

# Open a connection to the specified database
session = util.DbSession(database)

while 1:
	# Get the input, trapping for ctrl-D as
	# an exit statement
	try:
		input = raw_input('HQL> ')
	except EOFError:
		break
	
	# Run the user's command, trapping for any exceptions
	try:
		result = session.find(input)
		result_len = len(result)
		print "-------------------"

		if (result_len == 1):
			print " 1 record was returned" 
		else:
			print " %s records were returned" % result_len

		if (result_len > MAX_RESULTS):
			print " First %s records:" % MAX_RESULTS
			result_len = MAX_RESULTS
		
		for i in range(result_len):
			print " [%s] %s" % ( i, result[i] )
		print "-------------------"

	# Catch everything, including Java errors
	except:
		instance = sys.exc_info()[1]
		print "Error: %s" % str(instance)
	
# Goodbye!
print "\nThank you for using the HQL interpreter! Have a nice day."
