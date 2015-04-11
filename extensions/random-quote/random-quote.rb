require 'nokogiri'
require 'httparty'
require 'htmlentities'
require 'colorize'

def parse_quote(quote)
  character_count = 80
  text = quote.text.to_s.strip
  if text.length > 80
    count = 0
    array = text.split(' ')
    array.collect! do |word|
      count += word.length
      if count > 60
        count=0
        "#{word}\n   "
      else
        word
      end
    end
    text = array.join(' ')
  end
  text
end

# iheartquotes
# http://www.iheartquotes.com/api/v1/random?show_permalink=false

# begin
#   response = HTTParty.get('http://www.iheartquotes.com/api/v1/random?show_permalink=false')
#   print "\n #{HTMLEntities.new.decode(response.to_s)} \n".bold
# rescue Exception => e
#   print "\n No soup for you! -Soup Nazi".bold
#   print "\n Socket Error! Check your internet connection.".red.bold if e.is_a?(SocketError)
#   print "\n #{e} \n\n".red.bold
# end

# brainyquote
# http://www.brainyquote.com/quotes/keywords/random.html

# quotationspage
# http://www.quotationspage.com/random.php3

begin
  response = Nokogiri::HTML(HTTParty.get("http://www.quotationspage.com/random.php3"))
  quotes, authors = response.css('.quote'), response.css('.author')
  index = rand(0..19)

  text = parse_quote quotes[index]
  details = authors[index]
  details.css('.icons').remove
  details.css('.related').remove

  quote = {
    text: text,
    from: details.css('i').text,
    author: {
      name: details.css('a').remove.text,
      lifetime: details.css('b').text
    }
  }

  print "\n   \"#{quote[:text]}\" \n ".bold
  print "\n           - #{quote[:author][:name].strip}".light_white
  print " #{quote[:author][:lifetime].strip}".light_white
  print "\n               #{quote[:from].strip}".light_blue if quote
  print "\n\n"
rescue Exception => e
  print "\n   \"No soup for you!\"\n ".bold
  print "\n           - Soup Nazi".light_white
  print "\n               Seinfeld season 7, episode 6, 1995\n ".light_blue
  print "\n Socket Error! Check your internet connection.".red.bold if e.is_a?(SocketError)
  print "\n #{e} \n\n".red.bold
end
