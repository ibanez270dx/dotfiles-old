require 'nokogiri'
require 'httparty'
require 'optparse'

### Parse Command Line Arguments ###############################################

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: download_all [options]"

  opts.on("-o D", "--output D", "Output location") do |d|
    options[:output] = d
  end

  opts.on("-i", "--with-images", "Download with images") do |i|
    options[:with_images] = i
  end

  opts.on("-I", "--images-only", "Download images only") do |i|
    options[:images_only] = i
  end

  opts.on("-Y", "--yelp-images", "Download Yelp images") do |y|
    options[:yelp_images] = y
  end

  opts.on_tail("-h", "--help", "What you're looking at") do
    puts opts
    exit
  end
end.parse!

if ARGV.first.nil?
  puts "Please provide a URL"
  exit
elsif !ARGV.first.match(URI::regexp(%w(http https)))
  puts "Invalid URL"
  exit
else
  @url = ARGV.first
  puts "Parsing reply from #{@url}..."
end

### Parse Methods ##############################################################

def parse_anchor(element)
  link = case element['href']
  when /\A[\w|\d|\.|%|\(\)]+\z/
    {
      filename: element['href'],
      url: "#{@url}/#{element['href']}"
    }
  when /\Ahttp:\/\/.+\/[\w|\d|%|\(\)]+\.[\w|\d]\z/
    {
      filename: element['href'].match(/\/([\w|\d|\.|%|\(\)]+)\z/)[1],
      url: element['href']
    }
  else
    @items[:skipped] << element['href']
    puts "Warning: skipping link #{element['href']}"
  end
end

def parse_image(element)
  src = element.attributes["src"].value
  puts "src: #{src}"
  {
    filename: src.match(/\/[\w|\d|\.|\-|%|\(\)]+\z/)[1],
    url: "#{@url}#{src}"
  }
end

### Start Script ###############################################################

@items = { downloaded: [], skipped: [] }

if options[:output]
  @output = options[:output].chomp('/')
  mkdir = system("mkdir #{options[:output]}")
end

dom = Nokogiri::HTML HTTParty.get(@url)

# Inclusives
targets = ['a']
targets << 'img' if options[:with_images]

# Exclusives
targets = ['img'] if options[:images_only]

# Start
selector = targets.join(', ').chomp(', ')
dom.css(selector).each do |element|
  item = case element.name
  when 'a' then parse_anchor(element)
  when 'img' then parse_image(element)
  else
    puts "WTF, mate?"
    puts element.inspect
  end

  if item
    destination = @output ? "-o '#{@output}/#{item[:filename]}'" : "-O"
    cmd = "curl -s -S #{destination} '#{item[:url]}'"
    res = system(cmd)

    if res
      @items[:downloaded] << item[:url]
    else
      puts "Error executing the following command:\n  #{cmd}\n\n" unless res
    end
  end
end

# Remove created dir if it ends up empty
if mkdir && @items[:downloaded].count == 0
  system("rm -R #{options[:output]}")
end

puts "Downloaded #{@items[:downloaded].count} files, skipped #{@items[:skipped].count}"
