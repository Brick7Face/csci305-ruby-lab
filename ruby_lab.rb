
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <firstname> <lastname>
# <email-address>
#
###############################################################

$bigrams = Hash.new{|hsh,key| hsh[key] = {} } # The Bigram data structure
$name = "Nathanial Tranel"

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "
	begin
		IO.foreach(file_name, encoding: "UTF-8") do |line|
			title = cleanup_title(line)
			unless title.nil?
				words = title.split(/\s/)
				$i = 0
				until $i > (words.size-1) do
					if $bigrams["#{words[$i]}"]["#{words[$i+1]}"].nil?
						$bigrams["#{words[$i]}"].store "#{words[$i+1]}",1
					else
						j = $bigrams["#{words[$i]}"]["#{words[$i+1]}"]
						j += 1
						$bigrams["#{words[$i]}"]["#{words[$i+1]}"] = j
					end
					$i += 1
				end
			end
		end

		puts $bigrams["computer"]
		#puts mcw("sad")

		puts "Finished. Bigram model built.\n"
		rescue
			STDERR.puts "Could not open file"
			exit 4
	end
end


def cleanup_title(str)
	str.gsub!(/^.*>/, "")
	str.gsub!(/\s*(\(|\[|\{|\\|\/|_|-|:|"|`|\+|=|\*|feat\.).*$/, "")
	str.gsub!(/\?|\!|¿|¡|\.|;|\&|@|%|\#|\|/, "")
	if str =~ /[^\w^\s']/	#filter out nonenglish titles
		return nil
	end
	str.downcase!
	str
end

def mcw(word)
	i = 0
	val = 0
	common = ""
	until i == $bigrams["#{word}"].size do
		$bigrams["#{word}"].each {|key, value|
			unless key == ""
				if value > val
					val = value
					common = key
				end
			end
		}
		i += 1
	end
	common
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
