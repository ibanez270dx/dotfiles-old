require 'sinatra'
require 'json'

puts "starting sinatra..."

post '/' do
  data = JSON.parse(request.body.read)

  if data["pull_request"] && data["pull_request"]["assignee"]=="ibanez270dx"
    TerminalNotifier.notify data["pull_request"]["title"],
      title: "#{data["pull_request"]["user"]["login"].capitalize} #{data["action"]} a Pull Request",
      open: data["pull_request"]["html_url"]
  end

end
