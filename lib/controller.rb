require_relative 'scraper.rb'
require_relative 'csv_exporter.rb'

class Controller
  def initialize
    @keywords = []
    @freelancer
    @guru
    @peopleperhour
    @export_freelancer
    @export_guru
    @export_peopleperhour
    @scrape_freelancer
    @scrape_guru
    @scrape_peopleperhour
  end

  def run
    rule
    input
    init_scrape_object
    init_scraper
    sleep(2)
    begin_scraping

    puts "no job found in freelancing.com" if @scrape_freelancer == "no job found"
    puts "no job found in guru.com" if @scrape_guru == "no job found"
    puts "no job found in peopleperhour.com" if @scrape_peopleperhour == "no job found"

    if @scrape_freelancer == "no job found" && @scrape_guru == "no job found" && @scrape_peopleperhour == "no job found"
      return puts "No job found with the given keywords."
    else
      puts "Scraping complete!"
    end
    
    sleep(1)
    puts "Exporting to CSV..."
    init_exporter_object
    sleep(3)
    begin_exportation
    puts"Exportation complete!"
    sleep(1)
    puts "You will find 3 csv files in current working directory with the exported data."
    sleep(1)
    puts "Terminating..."
    sleep(2)
  end

  private
  def rule
    puts <<-MLS

       ____            __                       __     __     ____                         
      / __/______ ___ / /__ ____  _______   __ / /__  / /    / __/__________ ____  ___ ____
     / _// __/ -_) -_) / _ `/ _ \\/ __/ -_) / // / _ \\/ _ \\  _\\ \\/ __/ __/ _ `/ _ \\/ -_) __/
    /_/ /_/  \\__/\\__/_/\\_,_/_//_/\\__/\\__/  \\___/\\___/_.__/ /___/\\__/_/  \\_,_/ .__/\\__/_/   
                                                                           /_/             
    
Enter keywords to search jobs in these sites: freelance.com, guru.com, peopleperhour.com
If you have more than one keyword, enter each of them in separate lines. Once you are done, press Enter key to begin the search.
MLS
  end

  def input
    loop do
      input = gets
      break if input == "\n"
      @keywords << input.chomp
    end
  end

  def init_scrape_object
    @freelancer = Scraper.new(@keywords, "freelancer")
    @guru = Scraper.new(@keywords, "guru")
    @peopleperhour = Scraper.new(@keywords, "peopleperhour")
  end

  def init_scraper
    @scrape_freelancer = @freelancer.scrape
    @scrape_guru = @guru.scrape
    @scrape_peopleperhour = @peopleperhour.scrape
  end

  def begin_scraping
    @scrape_freelancer
    sleep(2)
    @scrape_guru
    sleep(2)
    @scrape_peopleperhour
  end

  def init_exporter_object
    @export_freelancer = CSVExporter.new(@scrape_freelancer, "freelancer")
    @export_guru = CSVExporter.new(@scrape_guru, "guru")
    @export_peopleperhour = CSVExporter.new(@scrape_peopleperhour, "peopleperhour")
  end

  def begin_exportation
    @export_freelancer.export unless @scrape_freelancer == "no job found"
    @export_guru.export unless @scrape_guru == "no job found"
    @export_peopleperhour.export unless @scrape_peopleperhour == "no job found"
  end
end

