
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Nathanial Tranel
# njtranel@gmail.com
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
					if words[$i].eql?("")
						$i += 1
					end
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
			unless key.eql?("")
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

def create_title(word)
	length = 0
	full_title = word
	print ("#{word } ")
	until ((length == 20) | ($bigrams["#{word}"].size == 0)) do
		word = mcw(word)
		print ("#{word } ")
		full_title = full_title + " " + word
		length += 1
	end
	print ("\n")
	full_title
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
	in_word = ""
	begin
		print ("Enter a word [Enter 'q' to quit]: ")
		in_word = $stdin.gets.chomp
		create_title(in_word)
	end until in_word.eql?("q")
end

if __FILE__==$0
	main_loop()
end
