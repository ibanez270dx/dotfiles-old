# Notifier.rb
#
# We've made a webhook for GitHub that is triggered on the following events"
#   commit_comment, deployment, deployment_status, issue_comment, issues,
#   pull_request_review_comment, pull_request, push, release, status
#

require 'socket'
require 'webrick'
require 'stringio'

server = TCPServer.new(5000)
parser = WEBrick::HTTPRequest.new(WEBrick::Config::HTTP)

puts "Listening on port 5000"

loop do
  # Wait until a client connects, then return a TCPSocket
  # that can be used in a similar fashion to other Ruby
  # I/O objects. (In fact, TCPSocket is a subclass of IO.)
  socket = server.accept

  # Parse the request using WEBrick
  # request = parser.parse(StringIO.new(socket.read))

  puts "====================="
  puts request.inspect
  puts "====================="
  puts request.path.inspect
  puts "====================="
  puts request.body.inspect
  puts "====================="


  response = "Hello World!\n"
  # We need to include the Content-Type and Content-Length headers
  # to let the client know the size and type of data
  # contained in the response. Note that HTTP is whitespace
  # sensitive, and expects each header line to end with CRLF (i.e. "\r\n")
  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"

  # Print a blank line to separate the header from the response body,
  # as required by the protocol.
  socket.print "\r\n"

  # Print the actual response body, which is just "Hello World!\n"
  socket.print response

  # Close the socket, terminating the connection
  socket.close

end
