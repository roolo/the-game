require 'rake'

desc 'Runs the game'
task :run, :res do |t, args|
  require './lib/game'

  game_attributes = {res: args[:res].split('x').map(&:to_i)} if args[:res]

  game_attributes ||= {}
  window = Game.new *game_attributes[:res]
  window.show
end
