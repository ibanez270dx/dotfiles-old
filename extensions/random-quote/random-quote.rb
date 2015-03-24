require 'httparty'
require 'htmlentities'
require 'colorize'

# iheartquotes
# http://www.iheartquotes.com/api/v1/random?show_permalink=false

begin
  response = HTTParty.get('http://www.iheartquotes.com/api/v1/random?show_permalink=false')
  print "\n #{HTMLEntities.new.decode(response.to_s)} \n".bold
rescue Exception => e
  print "\n No soup for you! -Soup Nazi".bold
  print "\n Socket Error! Check your internet connection.".red.bold if e.is_a?(SocketError)
  print "\n #{e} \n\n".red.bold
end
