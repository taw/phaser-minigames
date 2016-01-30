Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

randint = (a,b) ->
  a + Math.floor(Math.random() * (b-a+1))

class SpaceShip
  constructor: ->
    @x = size_x / 2
    @y = size_y / 2
    @angle = 0
    @dx = 0
    @dy = 0
    @graphics = game.add.graphics(@x, @y)
    @graphics.lineStyle(0)
    @graphics.beginFill(0x00FF00)
    @graphics.drawPolygon([
      0,   -20,
      15,   10,
      15,   20,
      -15,  20,
      -15,  10,
    ])
    @graphics.endFill()

  ensure_bounds: ->
    if @graphics.x < 20 and @dx < 0
      @dx = -@dx
    if @graphics.x > size_x-20 and @dx > 0
      @dx = -@dx
    if @graphics.y < 20 and @dy < 0
      @dy = -@dy
    if @graphics.y > size_y-20 and @dy > 0
      @dy = -@dy

  update: (dt) ->
    @graphics.x += @dx * dt
    @graphics.y += @dy * dt
    @graphics.angle = @angle
    @ensure_bounds()

  dir_x: ->
    Math.sin(Math.PI*2*@angle/360)

  dir_y: ->
    -Math.cos(Math.PI*2*@angle/360)

  limit_speed: ->
    dl = Math.sqrt(@dx*@dx + @dy*@dy)
    max_speed = 250.0
    if dl > max_speed
      @dx *= (max_speed/dl)
      @dy *= (max_speed/dl)

  speed_up: (dir, dt) ->
    speed_gain_per_second = 100.0
    @dx += @dir_x() * dt * speed_gain_per_second * dir
    @dy += @dir_y() * dt * speed_gain_per_second * dir
    @limit_speed()

  turn: (dir, dt) ->
    degrees_per_second = 400.0
    @angle += dir * dt * degrees_per_second

class Asteroid
  constructor: (x,y) ->
    @x  = x
    @y  = y
    angle = Math.random() * 2 * Math.PI
    speed = Math.random() * 400.0
    @dx = Math.cos(angle) * speed
    @dy = Math.sin(angle) * speed
    @graphics = game.add.graphics(@x, @y)
    @graphics.beginFill(0xFF0000)
    @graphics.drawCircle(0, 0, 20)

  update: (dt) ->
    @graphics.x += @dx * dt
    @graphics.y += @dy * dt
    @ensure_bounds()

  ensure_bounds: ->
    if @graphics.x < 20 and @dx < 0
      @dx = -@dx
    if @graphics.x > size_x-20 and @dx > 0
      @dx = -@dx
    if @graphics.y < 20 and @dy < 0
      @dy = -@dy
    if @graphics.y > size_y-20 and @dy > 0
      @dy = -@dy

class GameState
  constructor: ->
    null

  update: ->
    dt = @game.time.elapsed/1000.0
    if game.input.keyboard.isDown(Phaser.KeyCode.UP)
      @space_ship.speed_up(1.0, dt)
    if game.input.keyboard.isDown(Phaser.KeyCode.DOWN)
      @space_ship.speed_up(-1.0, dt)
    if game.input.keyboard.isDown(Phaser.KeyCode.LEFT)
      @space_ship.turn(-1.0, dt)
    if game.input.keyboard.isDown(Phaser.KeyCode.RIGHT)
      @space_ship.turn(1.0, dt)

    @space_ship.update(dt)
    for a in @asteroids
      a.update(dt)

  create: ->
    @game.stage.backgroundColor = "448"
    @space_ship = new SpaceShip
    @asteroids = for i in [0..9]
      while true
        x = randint(100, size_x-100)
        y = randint(100, size_y-100)
        break if Math.abs(x-size_x/2) + Math.abs(y-size_y/2) > 300
      new Asteroid(x, y)

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
