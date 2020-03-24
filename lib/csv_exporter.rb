require 'csv'

class CSVExporter
  def initialize(jobs, site)
    @jobs = jobs
    @site = site
  end

  def export
    CSV.open("#{@site}.com-jobs.csv", 'wb') do |row|
      row << @jobs.first.keys
      @jobs.each do |job|
        row << job.values
      end
    end
  end
end
