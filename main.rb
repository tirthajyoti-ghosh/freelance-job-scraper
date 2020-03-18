require 'nokogiri'
require 'httparty'
require 'csv'

puts "Search jobs by keywords in freelancer.com:"
keywords = gets.chomp
puts "Doing the hard work for you..."

search_url = "https://www.freelancer.com/jobs/?keyword=#{keywords}"
unparsed_page = HTTParty.get(search_url).body
parsed_page = Nokogiri::HTML(unparsed_page)

jobs = Array.new

job_listings = parsed_page.css('div.JobSearchCard-item')

page = 1
per_page = job_listings.count
total = parsed_page.css('span#total-results').text.to_i
last_page = (total.to_f / per_page.to_f).ceil.to_i

while page <= last_page
  pagination_url = "https://www.freelancer.com/jobs/#{page}/?keyword=#{keywords}"
  puts "Current url: #{pagination_url}"
  pagination_unparsed_page = HTTParty.get(pagination_url).body
  pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)

  pagination_job_listings = pagination_parsed_page.css('div.JobSearchCard-item')

  pagination_job_listings.each do |job_listing|
    job = {
      title: job_listing.css('a.JobSearchCard-primary-heading-link').text.strip.gsub(/\\n/, " "),
      rate: job_listing.css('div.JobSearchCard-secondary-price').text.delete(" ").delete("\n").delete("Avg Bid"),
      desc: job_listing.css('p.JobSearchCard-primary-description').text.strip,
      url: "https://www.freelancer.com" + job_listing.css('a.JobSearchCard-primary-heading-link')[0].attributes["href"].value
    }
  
    jobs << job
  end
  page += 1
end

CSV.open("test.csv", "wb") do |row|
  row << jobs.first.keys
  jobs.each do |job|
    row << job.values
  end
end

puts "Found #{last_page} pages containing #{total} jobs with your keywords."
