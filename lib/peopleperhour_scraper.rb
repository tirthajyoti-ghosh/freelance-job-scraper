require 'nokogiri'
require 'httparty'
require 'csv'

puts "Search jobs by keywords in freelancer.com:"
keywords = gets.chomp
puts "Doing the hard work for you..."

search_url = "https://www.peopleperhour.com/freelance-#{keywords}-jobs"
unparsed_page = HTTParty.get(search_url).body
parsed_page = Nokogiri::HTML(unparsed_page)

jobs = Array.new

job_listings = parsed_page.css('div.JobSearchCard-item')
