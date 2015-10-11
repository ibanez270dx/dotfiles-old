require 'colorize'
require 'date'

if ARGV.empty?
  puts "You must pass a valid date/time string.".red
else
  date = DateTime.parse(ARGV[0])
  date_str = date.strftime('%a %b %-d %T %Y %z')

  puts "Does #{date_str.blue} look correct? (y/N)".bold
  valid = STDIN.gets.chomp

  if %w(y yes).include?(valid.downcase)
    $/ = "END"
    puts "Enter your commit message. Type END to finish.".bold
    commit_msg = STDIN.gets.chomp
    system "GIT_AUTHOR_DATE='#{date_str}' GIT_COMMITTER_DATE='#{date_str}' git commit -m '#{commit_msg}'"
  end
end


# GIT_AUTHOR_DATE='your date' GIT_COMMITTER_DATE='your date' git commit -m 'new (old) files'
# GIT_AUTHOR_DATE='Fri Jul 26 19:32:10 2013 -0400' GIT_COMMITTER_DATE='Fri Jul 26 19:32:10 2013 -0400' git commit
