require 'nokogiri'
require 'httparty'
require 'csv'

puts "Search jobs by keywords in freelancer.com:"
keywords = gets.chomp
puts "Doing the hard work for you..."

search_url = "https://www.peopleperhour.com/freelance-#{keywords}-jobs"
uri = URI.parse(URI.encode(search_url.strip))
unparsed_page = HTTParty.get(uri).body
parsed_page = Nokogiri::HTML(unparsed_page)

jobs = Array.new

job_listings = parsed_page.css('div.job-items')[0].css('div.job-list-item')

page = 1
per_page = job_listings.count
total = parsed_page.css('span#job-listing-count').text.split(' ')[0].to_i
last_page = (total.to_f / per_page.to_f).ceil.to_i

puts "Found #{last_page} pages"

while page <= last_page
  pagination_url = search_url + "?page=#{page}"
  pagination_uri = URI.parse(URI.encode(pagination_url.strip))
  puts "Scraping page #{page}"

  pagination_unparsed_page = HTTParty.get(pagination_uri).body
  pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)

  pagination_job_listings = pagination_parsed_page.css('div.job-items')[0].css('div.job-list-item')

  pagination_job_listings.each do |job_listing|
    rate = job_listing.css('div.price-tag')
    rate.css('small').remove
    rate = rate.text.strip
    job = {
      title: job_listing.css('h6.title').css('a').text.strip,
      posted: job_listing.css('time.value').text.strip,
      rate: rate,
      proposals: job_listing.css('span.proposal-count').text,
      url: job_listing.css('h6.title').css('a')[0].attributes["href"].value
    }
  
    jobs << job
  end
  page += 1
end

CSV.open("csv/peopleperhour.com-jobs.csv", "wb") do |row|
  row << jobs.first.keys
  jobs.each do |job|
    row << job.values
  end
end

puts "Found #{jobs.count} jobs with your keywords."
