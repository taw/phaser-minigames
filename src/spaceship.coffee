Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class SpaceShip
  constructor: ->
    @x = size_x / 2
    @y = size_y / 2
    @angle = 0
    @speed = 0
    @graphics = game.add.graphics(@x, @y)
    @graphics.lineStyle(0)
    @graphics.beginFill(0xFF0000)
    @graphics.drawPolygon([
      0,   -20,
      15,   10,
      15,   20,
      -15,  20,
      -15,  10,
    ])
    @graphics.endFill()

  update: ->
    dx =  Math.sin(Math.PI*2*@angle/360) * @speed
    dy = -Math.cos(Math.PI*2*@angle/360) * @speed
    @graphics.x += dx
    @graphics.y += dy
    @graphics.angle = @angle

  speed_up: (dt) ->
    @speed += dt * 10.0
    if @speed > 10.0
      @speed = 10.0

  speed_down: (dt) ->
    @speed -= dt * 10.0
    if @speed < -10.0
      @speed = -10.0

  turn: (dir, dt) ->
    @angle += dir * dt * 100.0

class GameState
  constructor: ->
    null

  update: ->
    dt = @game.time.elapsed/1000.0
    if game.input.keyboard.isDown(Phaser.KeyCode.UP)
      @space_ship.speed_up(dt)
    if game.input.keyboard.isDown(Phaser.KeyCode.DOWN)
      @space_ship.speed_down(dt)
    if game.input.keyboard.isDown(Phaser.KeyCode.LEFT)
      @space_ship.turn(-1.0, dt)
    if game.input.keyboard.isDown(Phaser.KeyCode.RIGHT)
      @space_ship.turn(1.0, dt)

    @space_ship.update(dt)

  create: ->
    @game.stage.backgroundColor = "88F"
    @space_ship = new SpaceShip

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
