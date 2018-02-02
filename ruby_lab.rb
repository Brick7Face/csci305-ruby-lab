
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Nathanial Tranel
# njtranel@gmail.com
#
# The data structure used - a hash of hashes - stores a hash
# where the key is the first word in the bigram and the value
# is a hash where the key is the second bigram word and the
# value is the frequency with which that word occurs after
# the first.
###############################################################

$bigrams = Hash.new{|hsh,key| hsh[key] = {} } 	# The Bigram data structure - using a hash of hashes
$name = "Nathanial Tranel"											# constant for name

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "
	begin
		IO.foreach(file_name, encoding: "UTF-8") do |line|		# loop through each file line
			title = cleanup_title(line)													# for each line, cleanup the title
			unless title.nil?																		# don't proceed if title is nil - skip those
				words = title.split(/\s/)													# find the individual words in the title
				words.delete("a")
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


				(0..words.size-2).each do |i|
					if $bigrams["#{words[i]}"]["#{words[i+1]}"].nil?
						$bigrams["#{words[i]}"].store "#{words[i+1]}",1
					else
						$bigrams["#{words[i]}"]["#{words[i+1]}"] += 1
					end
				end
			end
		end
		puts "Finished. Bigram model built.\n"
		rescue
			STDERR.puts "Could not open file"
			exit 4
	end
end

# function to extract the title and remove unnecessary markings
def cleanup_title(str)
	title = ""
	if str =~ (/(^.*>)(.*)/)																							# extract title at end of string
		title = $2
	end
	title.gsub!(/\s*(\(|\[|\{|\\|\/|_|-|:|"|`|\+|=|\*|feat\.).*$/, "")		# remove special characters
	title.gsub!(/\?|\!|¿|¡|\.|;|\&|@|%|\#|\|/, "")												# remove punctuation
	if title =~ /(^\w^\s')/																								# filter out non-English titles
		return nil																													# if non-English, return empty title
	end
	title.downcase!																												# set title to lowercase
	title
end

# function to find the most common word that comes after the word provided as a parameter
def mcw(word)
	most = 0																							# represents the frequency with which the second word occurs
	common = ""																						# the most common word, initialized to the empty string
	$bigrams["#{word}"].each {|key, value|								# loop through each word following the given word
		unless key.eql?("")																	# skip if the word is the empty string
			if value > most																		# if the frequency of occurances is higher than the current highest,
				most = value																		# update it,
				common = key																		# and set the most common word to be the corresponding key
			end
		end
	}

	#experimental - deletes words at 0
	if $bigrams["#{word}"]["#{common}"] > 50
		$bigrams["#{word}"]["#{common}"] -= 50
	else
		$bigrams["#{word}"]["#{common}"] = 0
	end

	common																								# return the most common word
end

# function to generate a title based on an input word
def create_title(word)
	full_title = word																			# title will be just the word provided to start
	print ("#{word}")																			# print out the starting word
	19.times do
		break if $bigrams["#{word}"].size == 0
		word = mcw(word)																		# find the most common word that comes next
		print (" #{word}")																	# print it
		full_title = full_title + " " + word								# add the word to the full title
	end
	puts ("\n")																						# print new line for spacing
	full_title																						# return full title
end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])

	# Get user input
	while	true																						# loop for input ...
		print ("Enter a word [Enter 'q' to quit]: ")				# prompt the user,
		in_word = $stdin.gets.chomp													# get the input from STDIN, snipping off the \n
		break if in_word.eql?("q")													# break the loop if q is entered
		create_title(in_word)																# create a title if valid word is entered
	end
end

if __FILE__==$0
	main_loop()
end
