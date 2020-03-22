require_relative '../lib/scraper.rb'
require_relative '../lib/csv_exporter.rb'

puts <<~MLS

         ____            __                       __     __     ____
        / __/______ ___ / /__ ____  _______   __ / /__  / /    / __/__________ ____  ___ ____
       / _// __/ -_) -_) / _ `/ _ \\/ __/ -_) / // / _ \\/ _ \\  _\\ \\/ __/ __/ _ `/ _ \\/ -_) __/
      /_/ /_/  \\__/\\__/_/\\_,_/_//_/\\__/\\__/  \\___/\\___/_.__/ /___/\\__/_/  \\_,_/ .__/\\__/_/
                                                                             /_/

  Enter keywords to search jobs in these sites: freelancer.com, guru.com, peopleperhour.com
  If you have more than one keyword, enter each of them in separate lines. Once you are done, press Enter key to begin the search.
MLS

keywords = []

loop do
  input = gets
  break if input == "\n"

  keywords << input.chomp
end

freelancer = Scraper.new(keywords, 'freelancer')
guru = Scraper.new(keywords, 'guru')
peopleperhour = Scraper.new(keywords, 'peopleperhour')

sleep(2)

scrape_freelancer = freelancer.scrape
scrape_guru = guru.scrape
scrape_peopleperhour = peopleperhour.scrape

puts 'no job found in freelancing.com' if scrape_freelancer == 'no job found'
puts 'no job found in guru.com' if scrape_guru == 'no job found'
puts 'no job found in peopleperhour.com' if scrape_peopleperhour == 'no job found'

if scrape_freelancer == 'no job found' && scrape_guru == 'no job found' && scrape_peopleperhour == 'no job found'
  puts 'No job found with the given keywords.'
  abort
else
  puts "Scraping complete!\n\n"
end

sleep(1)

export_freelancer = CSVExporter.new(scrape_freelancer, 'freelancer')
export_guru = CSVExporter.new(scrape_guru, 'guru')
export_peopleperhour = CSVExporter.new(scrape_peopleperhour, 'peopleperhour')

puts "Exporting to CSV...\n\n"

sleep(3)

export_freelancer.export unless scrape_freelancer == 'no job found'
export_guru.export unless scrape_guru == 'no job found'
export_peopleperhour.export unless scrape_peopleperhour == 'no job found'

puts "Exportation complete!\n\n"

sleep(1)
puts "You will find 3 csv files in current working directory with the exported data.\n\n\n"
sleep(1)
puts "Terminating..."
sleep(2)
