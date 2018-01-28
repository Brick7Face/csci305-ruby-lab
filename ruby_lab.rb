
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <firstname> <lastname>
# <email-address>
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "Nathanial Tranel"

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		IO.foreach(file_name, encoding: "UTF-8") do |line|
			# do something for each line
			cleanup_title(line)
		end

		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

#USE A TRIE STRUCTURE FOR STORING BIGRAMS


def cleanup_title(str)
	title = str.gsub!(/^.*>/, "")
	title.gsub!(/\s*(\(|\[|\{|\\|\/|_|-|:|"|`|\+|=|\*|feat\.).*$/, "")
	title.gsub!(/\?|\!|¿|¡|\.|;|\&|@|%|\#|\|/, "")
	if title =~ /[^\w^\s']/	#filter out nonenglish titles
		return nil
	end
	title.downcase!
	title
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
end

if __FILE__==$0
	main_loop()
end
