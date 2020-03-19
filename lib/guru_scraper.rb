require 'nokogiri'
require 'httparty'
require 'csv'

puts "Search jobs by skills in guru.com. Input skills separated by space(' '):"
skills_raw = gets.chomp
skills = skills_raw.split(' ').join("/skill/")
puts "Doing the hard work for you..."

search_url = "https://www.guru.com/d/jobs/skill/#{skills}"
# puts search_url
unparsed_page = HTTParty.get(search_url).body
parsed_page = Nokogiri::HTML(unparsed_page)

job_listings = parsed_page.css('div.record__details')

jobs = Array.new

page = 1
per_page = job_listings.count
total = parsed_page.css('h2.secondaryHeading').text.split(' ')[0].to_i
last_page = (total.to_f / per_page.to_f).ceil.to_i

puts "Found #{last_page} pages"

while page <= last_page
  pagination_url = search_url + "/pg/#{page}"

  puts "Scraping page #{page}"

  pagination_unparsed_page = HTTParty.get(pagination_url).body
  pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)

  pagination_job_listings = pagination_parsed_page.css('div.record__details')

  pagination_job_listings.each do |job_listing|
    tags = []
    tags_text = job_listing.css('a.skillsList__skill')
    tags_text.each do |tag|
      tags << tag.text.strip
    end

    budget_array = []
    job_listing.css('div.jobRecord__budget').css('strong').each do |budget|
      budget_array << budget.text.strip
    end

    job = {
      title: job_listing.css('h2.jobRecord__title').text.strip,
      posted_by: job_listing.css('div.module_avatar').css('h3.identityName').text.strip,
      posted: job_listing.css('div.jobRecord__meta').css('strong')[0].text,
      send_before: job_listing.css('div.record__header__action').css('strong').text.strip,
      budget: budget_array.join(" , "),
      desc: job_listing.css('p.jobRecord__desc').text.strip,
      tags: tags.join(", "),
      url: "https://www.guru.com" + job_listing.css('h2.jobRecord__title').css('a')[0].attributes["href"].value
    }
  
    jobs << job
  end
  page += 1
end

CSV.open("csv/guru.com-jobs.csv", "wb") do |row|
  row << jobs.first.keys
  jobs.each do |job|
    row << job.values
  end
end

puts "Found #{jobs.count} jobs with your keywords."
