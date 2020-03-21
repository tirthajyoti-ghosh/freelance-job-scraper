require_relative 'lib/scraper.rb'
require_relative 'lib/csv_exporter.rb'

puts <<-MLS
    ______               __                             __      __       _____                                
   / ____/_______  ___  / /___ _____  ________         / /___  / /_     / ___/______________ _____  ___  _____
  / /_  / ___/ _ \\/ _ \\/ / __ `/ __ \\/ ___/ _ \\   __  / / __ \\/ __ \\    \\__ \\/ ___/ ___/ __ `/ __ \\/ _ \\/ ___/
 / __/ / /  /  __/  __/ / /_/ / / / / /__/  __/  / /_/ / /_/ / /_/ /   ___/ / /__/ /  / /_/ / /_/ /  __/ /    
/_/   /_/   \\___/\\___/_/\\__,_/_/ /_/\\___/\\___/   \\____/\\____/_.___/   /____/\\___/_/  /\\__,_/ .___/\\___/_/     
                                                                                          /_/                 

Enter keywords to search jobs in these sites: freelance.com, guru.com, peopleperhour.com
If you have more than one keyword, enter each of them in separate lines. Once you are done, press Enter key to begin the search.
MLS

keywords = []

loop do
  input = gets
  break if input == "\n"
  keywords << input.chomp
end

sleep(2)

freelancer = Scraper.new(keywords, "freelancer")
scrape_freelancer = freelancer.scrape

export_freelancer = CSVExporter.new(scrape_freelancer, "freelancer")


guru = Scraper.new(keywords, "guru")
scrape_guru = guru.scrape

export_guru = CSVExporter.new(scrape_guru, "guru")


peopleperhour = Scraper.new(keywords, "peopleperhour")
scrape_peopleperhour = peopleperhour.scrape

export_peopleperhour = CSVExporter.new(scrape_peopleperhour, "peopleperhour")

scrape_freelancer
sleep(2)
scrape_guru
sleep(2)
scrape_peopleperhour

puts "Scraping complete!"
sleep(1)
puts "Exporting to CSV..."
sleep(3)
export_freelancer.export
export_guru.export
export_peopleperhour.export
puts"Exportation complete!"
sleep(1)
puts "You will find 3 csv files in current directory with the exported data."
sleep(2)
puts "Terminating..."

