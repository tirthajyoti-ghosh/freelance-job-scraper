require_relative 'lib/scraper.rb'

puts "Welcome to Freelance job scraper."
puts "Enter keywords to search jobs in these sites: freelance.com, guru.com, peopleperhour.com"
puts "If you have more than one keyword, enter each of them in separate lines. Once you are done, press Enter key to begin the search"

keywords = []

loop do
  input = gets
  break if input == "\n"
  keywords << input.chomp
end

freelancer = Scraper.new(keywords, "freelancer")
guru = Scraper.new(keywords, "guru")
peopleperhour = Scraper.new(keywords, "peopleperhour")

puts "freelancer.com -> #{freelancer.scrape}"
puts "guru.com -> #{guru.scrape}"
puts "peopleperhour.com -> #{peopleperhour.scrape}"
