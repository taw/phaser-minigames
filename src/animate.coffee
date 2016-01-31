Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  update: ->
    null

  create: ->
    @game.stage.backgroundColor = "F88"
    @game.load.spritesheet('cat', 'images/cat_images/cat1.png', 37, 45, 18);

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
