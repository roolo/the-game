class Player
  attr_accessor :position_x, :position_y

  def initialize window
    @window = window
    @avatar = Gosu::Image.new window,
                              'media/avatar.png',
                              false
    @position_x = @position_y = @angle = 0.0
  end

  def warp x, y
    @position_x, @position_y = x, y
  end

  def position_x= x
    @position_x = x

    @position_x = 0 if @position_x > @window.width
    @position_x = @window.width if @position_x < 0
  end

  def draw
    @avatar.draw_rot @position_x, @position_y, 1, @angle
  end
end