require 'rake'

desc 'Runs the game'
task :run, :res do |t, args|
  require './lib/game'

  window = Game.new *args[:res].split('x').map(&:to_i)
  window.show
end
