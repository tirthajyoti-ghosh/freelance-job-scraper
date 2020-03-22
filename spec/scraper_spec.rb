require_relative 'spec_helper.rb'
require_relative '../lib/scraper.rb'

RSpec.describe Scraper do
  describe '#scrape' do
    it 'returns an array of jobs scraped from freelancer.com' do
      scraper = Scraper.new(["php", "ajax"], "freelancer")
      expect(scraper.scrape.class).to eql(Array)
    end

    it 'returns an array of jobs scraped from guru.com' do
      scraper = Scraper.new(["php", "ajax", "html"], "guru")
      expect(scraper.scrape.class).to eql(Array)
    end

    it 'returns an array of jobs scraped from peopleperhour.com' do
      scraper = Scraper.new(["ruby", "react js"], "peopleperhour")
      expect(scraper.scrape.class).to eql(Array)
    end

    it "returns 'no job found' when freelancer.com fails to scrape with given keywords" do
      scraper = Scraper.new(["sfdgsdfg", "sfvgsfx"], "freelancer")
      expect(scraper.scrape).to eql('no job found')
    end

    it "returns 'no job found' when guru.com fails to scrape with given keywords" do
      scraper = Scraper.new(["ergdfdfg", "grtysfx"], "guru")
      expect(scraper.scrape).to eql('no job found')
    end

    it "returns 'no job found' when peopleperhour.com fails to scrape with given keywords" do
      scraper = Scraper.new(["sf45essdfg", "nghjfx"], "peopleperhour")
      expect(scraper.scrape).to eql('no job found')
    end
  end
end
