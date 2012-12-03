require 'cane/rake_task'

LAST_BUILD_COVERAGE_FILE = "coverage/covered_percent"

desc "Run cane to check quality metrics"
Cane::RakeTask.new(:quality) do |cane|
  cane.canefile = '.cane'
end
