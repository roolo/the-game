require 'gosu'
require_relative './game/player'

class Game < Gosu::Window
  def initialize width=640, height=480
    super width, height, false
    self.caption = 'The Game'

    @background_image = Gosu::Image.new self, 'media/background.png', true
    @player = Player.new self
    @player.warp width/2, height/2
  end

  # Called for every frame
  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.position_x -= 5
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.position_x += 5
    end
  end

  # Draws screen
  def draw
    @background_image.draw 0, 0, 0
    @player.draw
  end

  def button_down id
    if id == Gosu::KbEscape
      close
    end
  end
end