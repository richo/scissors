require './lib/scissors/server'

map '/prefix' do
  app = Scissors::Server.new do |app|
  end
  run app
end
