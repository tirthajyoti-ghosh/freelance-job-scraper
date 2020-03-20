require 'nokogiri'
require 'httparty'

class Scraper
  def initialize(keywords)
    @keywords = keywords
    @jobs = Array.new
  end

  def scrape
    parse_keywords
    make_url(1) # takes page number as parameter
    parse_url

  end
  
  private
  def parse_keywords
    @freelancer_keywords = @keywords.join(' ')
    @peopleperhour_keywords = @keywords.join(' ')
    @guru_keywords = @keywords.join("/skill/")
  end

  def make_url(page)
    @freelancer_url = "https://www.freelancer.com/jobs/#{page}/?keyword=#{@freelancer_keywords}"
    @guru_url = "https://www.guru.com/d/jobs/skill/#{guru_keywords}/pg/#{page}"
    @peopleperhour_url = "https://www.peopleperhour.com/freelance-#{peopleperhour_keywords}-jobs?page=#{page}"
  end

  def parse_url
    @freelancer_uri = URI.parse(URI.encode(@freelancer_url.strip))
    @guru_uri = URI.parse(URI.encode(@guru_url.strip))
    @peopleperhour_uri = URI.parse(URI.encode(@peopleperhour_url.strip))
  end

  def parse_html(parsed_uri)
    unparsed_page = HTTParty.get(parsed_uri).body
    parsed_page = Nokogiri::HTML(unparsed_page)
    parsed_page
  end

  def last_page
    job_listings = parsed_page.css('div.JobSearchCard-item')

    page = 1
    per_page = job_listings.count
    total = parsed_page.css('span#total-results').text.to_i
    last_page = (total.to_f / per_page.to_f).ceil.to_i
  end

  def scrape_freelancer

  end

  def scrape_guru

  end

  def scrape_peopleperhour
    
  end
end
