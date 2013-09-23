require 'gosu'
require 'chipmunk'
require_relative './game/player'
require_relative './game/tools'

class Game < Gosu::Window
  attr_accessor :space
  def initialize width=640, height=480
    super width, height, false
    self.caption = 'The Game'

    @background_image = Gosu::Image.new self, 'media/background.png', true

    player_body = CP::Body.new(10.0, 150.0)

    player_shape = CP::Shape::Poly.new player_body,
                                       [  CP::Vec2.new(-25.0, -25.0),
                                          CP::Vec2.new(-25.0, 25.0),
                                          CP::Vec2.new(25.0, 1.0),
                                          CP::Vec2.new(25.0, -1.0)
                                       ],
                                       CP::Vec2.new(0, 0)
    player_shape.collision_type = :player

    init_environment  player_shape, player_body
    init_world_boundaries
    init_player       player_shape
  end

  def init_environment shape, player_body
    @space = CP::Space.new
    @space.damping =  0.8
    @space.add_body   player_body
    @space.add_shape  shape
    @space.gravity =  CP::Vec2.new(0.0, 100)
  end

  def init_player shape
    @player = Player.new self, shape
    @player.warp CP::Vec2.new(width/1.5, height/1.5)
  end

  def init_world_boundaries
    padding = 10.0 # amount the wall hangs off the edge of the screen
    roof_height = 200.0

    # bottom wall
    wall_shape = CP::Shape::Segment.new CP::Body.new_static(),
                                        CP::Vec2.new(0.0-padding, height),
                                        CP::Vec2.new(width+padding, height),
                                        1.0
    wall_shape.collision_type = :wall
    # friction
    wall_shape.u = 0.5
    # elasticity
    wall_shape.e = 0.0
    @space.add_static_shape(wall_shape)

    # Rest of boundaries vectors for left, right, top (in this order)
    #   side [  [ from_x, from_y],
    #           [ to_x,   to_y]
    #        ]
    #
    [ [ [0.0,         height+padding],
        [0.0,         0.0-padding-roof_height]
      ],
      [ [width,       height+padding],
        [0.0,         0.0-padding-roof_height]
      ],
      [ [0.0-padding, 0.0-roof_height],
        [0.0,         0.0-padding-roof_height]
      ],


    ].each do |from, to|
      wall_shape = CP::Shape::Segment.new CP::Body.new_static(),
                                          CP::Vec2.new(*from),
                                          CP::Vec2.new(*to),
                                          1.0
      wall_shape.collision_type = :wall
      @space.add_shape(wall_shape)
    end

    # walls cannot bump into each other
    @space.add_collision_func(:wall, :wall, &nil)
  end

  # Called for every frame
  def update
    @player.shape.body.reset_forces

    6.times do
      if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
        @player.move_left
      end
      if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
        @player.move_right
      end
      #if button_down? Gosu::KbUp or button_down? Gosu::GpRight then
      #  @player.shape.body.a += 0.1
      #
      #  puts @player.shape.body.a.inspect
      #end
      #if button_down? Gosu::KbDown or button_down? Gosu::GpRight then
      #  @player.shape.body.a -= 0.1
      #  puts @player.shape.body.a.inspect
      #end


      @space.step 1.0/10.0
    end
  end

  # Draws screen
  def draw
    @background_image.draw 0, 0, ZOrder::BACKGROUND
    @player.draw
  end

  def button_down id
    if id == Gosu::KbEscape
      close
    end
  end
end
