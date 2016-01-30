Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  update: ->
    dx = @game.input.activePointer.worldX - size_x/2
    dy = @game.input.activePointer.worldY - size_y/2
    dl = Math.sqrt(dx*dx + dy*dy)
    if dl > 40
      dx = 40*dx/dl
      dy = 40*dy/dl
    @retina.x = size_x/2 + dx
    @retina.y = size_y/2 + dy

  create: ->
    @game.stage.backgroundColor = "F88"

    @eye = game.add.graphics(size_x / 2, size_y / 2)
    @eye.beginFill(0xFFFFFF)
    @eye.lineStyle(5, 0x000000, 1)
    @eye.drawCircle(0, 0, 200)
    @eye.endFill()

    @retina = game.add.graphics(size_x / 2, size_y / 2)
    @retina.beginFill(0x000000)
    @retina.lineStyle(3, 0x000000, 1)
    @retina.drawCircle(0, 0, 100)
    @retina.endFill()

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
