require 'nokogiri'
require 'httparty'

class Scraper
  def initialize(keywords, site)
    @keywords = keywords
    @site = site
    @jobs = []
  end

  def scrape
    page = 1
    last_page = last_page(@site, parse_html(make_url(@site, 1)))
    return 'no job found' if last_page.zero?

    while page <= last_page
      parsed_html = parse_html(make_url(@site, page))

      case @site
      when 'freelancer'
        scrape_freelancer(parsed_html)
      when 'guru'
        scrape_guru(parsed_html)
      else
        scrape_peopleperhour(parsed_html)
      end

      page += 1
    end

    @jobs
  end

  private

  def parse_keywords
    @keywords.map! { |keyword| keyword.gsub(' ', '-') }
    search_query = if @site == 'freelancer' || @site == 'peopleperhour'
                     @keywords.join('%20')
                   else
                     @keywords.join('/skill/')
                   end
    search_query
  end

  def make_url(site, page)
    search_url = case site
                 when 'freelancer'
                   "https://www.freelancer.com/jobs/#{page}/?keyword=#{parse_keywords}"
                 when 'guru'
                   "https://www.guru.com/d/jobs/skill/#{parse_keywords}/pg/#{page}"
                 else
                   "https://www.peopleperhour.com/freelance-#{parse_keywords}-jobs?page=#{page}"
                 end
    search_url
  end

  def parse_html(url)
    unparsed_page = HTTParty.get(url).body
    parsed_page = Nokogiri::HTML(unparsed_page)
    parsed_page
  end

  def last_page(site, parsed_page)
    case site
    when 'freelancer'
      job_listings = parsed_page.css('div.JobSearchCard-item')
      total = parsed_page.css('span#total-results').text.gsub(',', '').to_f
    when 'guru'
      job_listings = parsed_page.css('div.jobRecord')
      total = parsed_page.css('h2.secondaryHeading').text.split(' ')[0].gsub(',', '').to_f
    else
      job_listings = parsed_page.css('div.job-items')[0].css('div.job-list-item')
      total = parsed_page.css('span#job-listing-count').text.split(' ')[0].gsub(',', '').to_f
    end

    return 0 if job_listings.count.zero?

    per_page = job_listings.count.to_f
    last_page = (total / per_page).ceil.to_i
    last_page
  end

  def scrape_freelancer(parsed_html)
    job_listings = parsed_html.css('div.JobSearchCard-item')
    job_url = 'https://www.freelancer.com'

    job_listings.each do |job_listing|
      tags = []
      tags_text = job_listing.css('a.JobSearchCard-primary-tagsLink')
      tags_text.each do |tag|
        tags << tag.text
      end
      job = {
        title: job_listing.css('a.JobSearchCard-primary-heading-link').text.strip.gsub(/\\n/, ' '),
        rate: job_listing.css('div.JobSearchCard-secondary-price').text.delete(' ').delete("\n").delete('Avg Bid'),
        desc: job_listing.css('p.JobSearchCard-primary-description').text.strip,
        tags: tags.join(', '),
        url: job_url + job_listing.css('a.JobSearchCard-primary-heading-link')[0].attributes['href'].value
      }

      @jobs << job
    end

    @jobs
  end

  def scrape_guru(parsed_html)
    parsed_html.css('div.record__details').each do |job_listing|
      tags = []
      job_listing.css('a.skillsList__skill').each { |tag| tags << tag.text.strip }

      budget_array = []
      job_listing.css('div.jobRecord__budget').css('strong').each do |budget|
        budget_array << budget.text.strip
      end

      job = {
        title: job_listing.css('h2.jobRecord__title').text.strip,
        posted_by: job_listing.css('div.module_avatar').css('h3.identityName').text.strip,
        posted: job_listing.css('div.jobRecord__meta').css('strong')[0].text,
        send_before: job_listing.css('div.record__header__action').css('strong').text.strip,
        budget: budget_array.join(' , '),
        desc: job_listing.css('p.jobRecord__desc').text.strip,
        tags: tags.join(', '),
        url: 'https://www.guru.com' + job_listing.css('h2.jobRecord__title').css('a')[0].attributes['href'].value
      }

      @jobs << job
    end

    @jobs
  end

  def scrape_peopleperhour(parsed_html)
    job_listings = parsed_html.css('div.job-items')[0].css('div.job-list-item')

    job_listings.each do |job_listing|
      rate = job_listing.css('div.price-tag')
      rate.css('small').remove
      rate = rate.text.strip
      job = {
        title: job_listing.css('h6.title').css('a').text.strip,
        posted: job_listing.css('time.value').text.strip,
        rate: rate,
        proposals: job_listing.css('span.proposal-count').text,
        url: job_listing.css('h6.title').css('a')[0].attributes['href'].value
      }

      @jobs << job
    end

    @jobs
  end
end
