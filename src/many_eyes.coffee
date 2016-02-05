Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class Eye
  constructor: (i) ->
    cx = (i % 4) * size_x / 4
    cy = ~~(i / 4) * size_y / 4

    @x = game.rnd.between(cx + 50, cx + size_x / 4 - 50)
    @y = game.rnd.between(cy + 50, cy + size_y / 4 - 50)
    @eyesize = game.rnd.between(50,200)
    @max_eye_movement = @eyesize * 0.2
    @eye = game.add.graphics(@x, @y)
    @eye.beginFill(0xFFFFFF)
    @eye.lineStyle(5, 0x000000, 1)
    @eye.drawCircle(0, 0, @eyesize)
    @eye.endFill()
    @retina = game.add.graphics(@x, @y)
    @retina.beginFill(0x000000)
    @retina.lineStyle(3, 0x000000, 1)
    @retina.drawCircle(0, 0, @eyesize*0.5)
    @retina.endFill()

  update: (mx, my) ->
    dx = mx - @x
    dy = my - @y
    dl = Math.sqrt(dx*dx + dy*dy)
    if dl > @max_eye_movement
      dx = @max_eye_movement*dx/dl
      dy = @max_eye_movement*dy/dl
    @retina.x = @x + dx
    @retina.y = @y + dy

class GameState
  update: ->
    for eye in @eyes
      eye.update(
        @game.input.activePointer.worldX,
        @game.input.activePointer.worldY
      )

  create: ->
    @game.stage.backgroundColor = "F88"
    @eyes = (new Eye(i) for i in [0...16])

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
