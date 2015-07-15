################################################################################
# amazing-facts.rb
#   A simple class to serve up amazing facts from MentalFloss' API. When there
#   aren't any "unseen" facts left, it will automatically fetch and store more.
################################################################################

require 'nokogiri'
require 'httparty'
require 'sqlite3'
require 'ostruct'
require 'colorize'

class AmazingFacts

  def initialize
    # DB name and location
    @name = "amazing_facts"
    @file = "#{ENV['DOTFILES']}/extensions/#{@name.gsub('_','-')}/#{@name}.db"

    # Open or create the DB
    if File.exists?(@file)
      @db = SQLite3::Database.open @file
    else
      @db = SQLite3::Database.new @file
      @db.execute <<-SQL
        CREATE TABLE #{@name} (
          id INTEGER PRIMARY KEY,
          fact TEXT UNIQUE NOT NULL,
          author VARCHAR(255),
          seen INTEGER DEFAULT 0
        );
      SQL
    end
  end

  def fetch_more_facts
    # Display message
    print "Oops, no fresh facts! Fetching more...".red

    # Grab some more facts from the MentalFloss API
    endpoint = "http://mentalfloss.com/api/1.0/views/amazing_facts.json"
    response = HTTParty.get("#{endpoint}?limit=500&cb=#{count()}")

    # Parse facts and insert into DB
    JSON.parse(response.body).each do |fact|
      add_fact Nokogiri::HTML(fact['nid']).text(), fact['submitted by']
    end
  end

  def count
    @db.execute "SELECT id FROM #{@name} ORDER BY id desc LIMIT 1;"
  end

  def add_fact(fact, author)
    @db.execute "INSERT OR IGNORE INTO #{@name} (fact, author) VALUES (?, ?);", [ fact, author ]
  end

  def get_fact
    # Grab a random, unseen fact from the DB.
    fact = @db.execute "SELECT * FROM #{@name} WHERE seen = 0 ORDER BY RANDOM() LIMIT 1;"

    if fact.empty?
      fetch_more_facts and get_fact
    else
      # Mark the fact as "seen" and return a struct.
      @db.execute "UPDATE #{@name} SET seen = 1 WHERE id = ?", fact[0][0]
      OpenStruct.new({ id: fact[0][0], body: fact[0][1], author: fact[0][2] })
    end
  end

  def display_fact
    fact = get_fact
    print "\n   #{word_wrap(fact.body)} \n ".bold
    if fact.author && fact.author.strip != ""
      author = fact.author.strip.gsub(" -","\n#{14*" "}")
      print "\n#{10*" "} - #{author}".light_blue
    end
    print "\n\n"
  end

  # stolen from Rails (gasp!) w/ some added whitespace for padding
  # http://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html#method-i-word_wrap
  def word_wrap(text, options = {})
    line_width = options.fetch(:line_width, 80)
    text.split("\n").collect! do |line|
      line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n   ").strip : line
    end * "\n"
  end
end

db = AmazingFacts.new
db.display_fact
