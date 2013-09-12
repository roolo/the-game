class Player
  # @!attribute shape
  #   @return [CP::Shape::Poly]
  attr_accessor :shape

  # @param [Game] window Base of the game / Main window
  # @param [CP::Shape::Poly] shape Shape of player
  def initialize window, shape
    @window = window
    @avatar = Gosu::Image.new @window,
                              'media/avatar.png',
                              false

    @shape = shape
    @shape.body.p = CP::Vec2.new( @window.width/2,
                                  @window.height/2) # position
    @shape.body.v = CP::Vec2.new(1.0, 1.0) # velocity
    @shape.body.a = (3*Math::PI/1.0) # angle in radians; faces towards top of screen
  end

  # @param [CP::Vec2] vector Position where we want player
  def warp vector
    @shape.body.p = vector
  end

  # Moves player to left a bit
  def move_left
    @shape.body.apply_force (@shape.body.a.radians_to_vec2*10),
                            CP::Vec2.new(0.0, 0.0)
  end

  # Moves player to right a bit
  def move_right
    @shape.body.apply_force -(@shape.body.a.radians_to_vec2*10),
                            CP::Vec2.new(0.0, 0.0)
  end



  def draw
    @avatar.draw_rot  @shape.body.p.x,
                      @shape.body.p.y,
                      ZOrder::PLAYER,
                      @shape.body.a.radians_to_gosu
  end
end
