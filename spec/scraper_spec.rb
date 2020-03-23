require_relative 'spec_helper.rb'
require_relative '../lib/scraper.rb'

require 'nokogiri'

RSpec.describe Scraper do
  describe '.scrape_freelancer' do
    let(:raw_html) { '<div class="JobSearchCard-item "><div class="JobSearchCard-item-inner" data-project-card="true"><div class="JobSearchCard-primary"><div class="JobSearchCard-primary-heading"> <a href="/projects/php/develop-website-24431323/" class="JobSearchCard-primary-heading-link" data-qtsb-section="page-job-search-new" data-qtsb-subsection="card-job" data-qtsb-label="link-project-title" data-heading-link="true"> Develop My Website </a></div><p class="JobSearchCard-primary-description"> This is an online Social Blogging forum! built on <b>PHP</b> [login to view URL]! [login to view URL]Please check the Website throughly and then Quote!You may have to complete the front end and built an admin panel as well!You may have to design and develop in ci! so knowledge in CI , web designing and Photoshop is prerequisite!</p><div class="JobSearchCard-primary-tags" data-qtsb-section="page-job-search-new" data-qtsb-subsection="card-job" data-qtsb-label="link-skill"> <a class="JobSearchCard-primary-tagsLink" href="/jobs/codeigniter/">Codeigniter</a> <a class="JobSearchCard-primary-tagsLink" href="/jobs/graphic-design/">Graphic Design</a> <a class="JobSearchCard-primary-tagsLink" href="/jobs/html/">HTML</a> <a class="JobSearchCard-primary-tagsLink" href="/jobs/php/">PHP</a> <a class="JobSearchCard-primary-tagsLink" href="/jobs/website-design/">Website Design</a></div></div><div class="JobSearchCard-secondary"><div class="JobSearchCard-secondary-price"> $117</div></div></div></div>' }

    let(:parsed_html) { Nokogiri::HTML(raw_html) }

    let(:scraper) { Scraper.new(%w[any keyword], "any_site") }

    it 'returns an array' do
      expect(scraper.send(:scrape_freelancer, parsed_html).class).to eql(Array)
    end

    it 'returns an array of hashes' do
      expect(scraper.send(:scrape_freelancer, parsed_html)[0].class).to eql(Hash)
    end    
  end

  describe '.parse_keywords' do
    let(:scraper) { Scraper.new(['react js', 'ruby on rails'], 'peopleperhour') }
    let(:guru) { Scraper.new(%w[php ajax html], 'guru') }

    it 'returns string of parsed keywords for freelancer.com or peopleperhour.com' do
      expect(scraper.send(:parse_keywords)).to eql('react-js%20ruby-on-rails')
    end
    
    it 'returns string of parsed keywords for guru.com' do
      expect(guru.send(:parse_keywords)).to eql('php/skill/ajax/skill/html')
    end
  end

  describe '.make_url' do
    let(:freelancer) { Scraper.new(['any', 'keywords'], 'freelancer') }
    let(:peopleperhour) { Scraper.new(['react js', 'ruby on rails'], 'peopleperhour') }
    let(:guru) { Scraper.new(%w[php ajax html], 'guru') }

    it 'return freelancer.com search url after taking site and page as param' do
      expect(freelancer.send(:make_url, 'freelancer', 4)).to eql('https://www.freelancer.com/jobs/4/?keyword=any%20keywords')
    end
    
    it 'return guru.com search url after taking site and page as param' do
      expect(guru.send(:make_url, 'guru', 5)).to eql('https://www.guru.com/d/jobs/skill/php/skill/ajax/skill/html/pg/5')
    end
    
    it 'return peopleperhour.com search url after taking site and page as param' do
      expect(peopleperhour.send(:make_url, 'peopleperhour', 2)).to eql('https://www.peopleperhour.com/freelance-react-js%20ruby-on-rails-jobs?page=2')
    end
  end
end
