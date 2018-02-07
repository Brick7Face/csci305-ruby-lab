
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Nathanial Tranel
# njtranel@gmail.com
#
# The data structure used here was a hash of a hash with an
# array - the first hash key is the first word in the bigram,
# and the second hash is the value of the first hash. In the
# second (or inner hash), the key is the second word in the
# bigram and the value is an array holding the number of
# occurences of the song and a boolean flagging whether or
# not the song has been used or not.
###############################################################

$bigrams = Hash.new{|hsh,key| hsh[key] = Hash.new{|hsh,key| hsh[key] = Array.new} } 	# The Bigram data structure - using a hash of hashes
$name = "Nathanial Tranel"											# constant for name

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "
	begin
		IO.foreach(file_name, encoding: "UTF-8") do |line|		# loop through each file line
			title = cleanup_title(line)													# for each line, cleanup the title
			unless title.nil?																		# don't proceed if title is nil - skip those
				words = title.split(/\s/)													# find the individual words in the title
				words.delete("a")																	# don't add these stop words to the bigrams structure
				words.delete("an")
				words.delete("and")
				words.delete("by")
				words.delete("for")
				words.delete("from")
				words.delete("in")
				words.delete("of")
				words.delete("on")
				words.delete("or")
				words.delete("out")
				words.delete("the")
				words.delete("to")
				words.delete("with")

				(0..words.size-2).each do |i|																				# for each word in the title
					if $bigrams["#{words[i]}"]["#{words[i+1]}"][0].nil?								# if the value does not yet exist for the current word,
						$bigrams["#{words[i]}"].store("#{words[i+1]}", [1, false])			# create it and update values (1 occurence, false for it has not been used)
					else
						$bigrams["#{words[i]}"]["#{words[i+1]}"][0] += 1								# otherwise simply increment the counter for the bigram
					end
				end
			end
		end
		puts "Finished. Bigram model built.\n"

	rescue																																		# catch block for any errors processing file
		STDERR.puts "Could not open file"
		exit 4
	end
end

# function to extract the title and remove unnecessary markings
def cleanup_title(str)
	title = ""																														# initialize the title to the empty string
	if str =~ (/(^.*>)(.*)/)																							# extract title at end of string (if it matches the second group)
		title = $2
	end
	title.gsub!(/\s*(\(|\[|\{|\\|\/|_|-|:|"|`|\+|=|\*|feat\.).*$/, "")		# remove special characters - replace that portion with empty string
	title.gsub!(/\?|\!|¿|¡|\.|;|\&|@|%|\#|\|/, "")												# remove punctuation - replace that portion with empty string
	if title =~ /(^\w^\s')/																								# filter out non-English titles
		return nil																													# if non-English, return empty title (filtered out in word array)
	end
	title.downcase!																												# set title to lowercase
	title																																	# return the cleaned title
end

# function to find the most common word that comes after the word provided as a parameter
def mcw(word)
	begin
		most = 0																							# represents the frequency with which the second word occurs
		common = ""																						# the most common word, initialized to the empty string
		$bigrams["#{word}"].each {|key, value|								# loop through each word following the given word
			if value[0] > most and value[1] == false						# if the frequency of occurances is higher than the current highest,
				most = value[0]																		# update it,
				common = key																			# and set the most common word to be the corresponding key
			end
		}
		$bigrams["#{word}"]["#{common}"][1] = true						# for the most common word, set it's usage flag to true
	rescue
		common = ""																						# in case errors are thrown (for running out of words after the first) set the mcw to the empty string
	end
	common																									# return the most common word
end

# function to generate a title based on an input word
def create_title(word)
	full_title = word																			# title will be just the word provided to start
	print ("#{word}")																			# print out the starting word
	while true																						# loop until a breaking condition - if none are reached, continue to generate song title
		word = mcw(word)																		# find the most common word that comes next
		break if word.eql?("")															# end the title generation if the next word is nothing
		break if full_title.include? word										# end the title generation if the title already has the next word (and it's not nothing)
		print (" #{word}")																	# print the next word
		full_title = full_title + " " + word								# add the word to the full title
	end
	puts ("\n")																						# print new line for spacing
	full_title																						# return full title
end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1																		# make sure a file is provided
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])																	# preprocessing for title generation

	# Get user input
	while	true																						# loop for input until user decides to quit
		print ("Enter a word [Enter 'q' to quit]: ")				# prompt the user for the first word
		in_word = $stdin.gets.chomp													# get the input from STDIN, snipping off the \n
		break if in_word.eql?("q")													# exit if q is entered
		create_title(in_word)																# create a title if a valid word is entered
	end
end

if __FILE__==$0
	main_loop()
end
