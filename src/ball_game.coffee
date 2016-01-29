Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  constructor: ->
    @balls = []

  new_ball: (x,y) ->
    @balls.push new Ball(x, y)

  update: ->
    dt = @game.time.elapsed/1000.0
    # Elapsed time only counts when game was actually running (so not in background)
    for ball in @balls
      ball.update(dt)

  create: ->
    @game.stage.backgroundColor = "88F"
    @game.input.onTap.add =>
      @new_ball @game.input.activePointer.worldX, @game.input.activePointer.worldY

class Ball
  constructor: (@x, @y) ->
    @dx = 0
    @dy = 0
    @ensure_bounds()
    @random_direction()
    @graphics = game.add.graphics(@x, @y)
    @graphics.lineStyle(0)
    @graphics.beginFill(Math.random() * 0xFFFFFF)
    @graphics.drawCircle(0, 0, 5)
    @graphics.endFill()

  ensure_bounds: () ->
    # These are min/max for ball, not for game state, so +-5 is calculated here
    # Otherwise we'd need to do bounding box/bounding box intersections,
    # and it would be unnecessarily complex
    min_x = 5
    max_x = size_x-5
    min_y = 5
    max_y = size_y-5
    bounce = false
    if @x < min_x
      @x = min_x
      @dx = -@dx
      bounce = true
    if @x > max_x
      @x = max_x
      @dx = -@dx
      bounce = true
    if @y < min_y
      @y = min_y
      @dy = -@dy
      bounce = true
    if @y > max_y
      @y = max_y
      @dy = -@dy
      bounce = true
    if bounce
      # Make sure objects lose some energy on bounce so they eventually stop
      @dx *= 0.8
      @dy *= 0.8

  random_direction: ->
    angle = Math.random() * 2 * Math.PI
    speed = Math.random() * 400.0
    @dx = Math.cos(angle) * speed
    @dy = Math.sin(angle) * speed

  update: (dt) ->
    @dy += 20.0*dt # gravity
    @x  += @dx*dt
    @y  += @dy*dt
    @ensure_bounds()
    @graphics.x = @x
    @graphics.y = @y

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
