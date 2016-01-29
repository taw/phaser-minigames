Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

randint = (a,b) ->
  a + Math.floor(Math.random() * (b-a))

random_color = ->
  Math.random() * 0xFFFFFF

class GameState
  constructor: ->
    @shapes = []
    @shape_timer = 0

  update: ->
    dt = @game.time.elapsed/1000.0
    @shape_timer += dt
    # Only update after enough time elapsed, not every frame
    if @shape_timer > 0.1 or @shapes.length < 50
      if @shapes.length >= 100
        s = @shapes.shift()
        s.destroy()
      @shapes.push(new Shape)
      @shape_timer = 0
    for s in @shapes
      s.update(dt)

  create: ->
    @game.stage.backgroundColor = "040"

class Shape
  constructor: ->
    @active = true
    @x = randint(0, size_x)
    @y = randint(0, size_y)
    @graphics = game.add.graphics(@x, @y)
    @graphics.lineStyle(0)
    @graphics.beginFill(random_color())
    @graphics.drawCircle(0, 0, randint(5, 100))
    @graphics.endFill()

  update: (dt) ->
    null

  destroy: ->
    console.log(@graphics)
    @graphics.destroy()

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
