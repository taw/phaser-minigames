Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  constructor: ->
    null

  update: ->
    null

  create: ->
    @game.stage.backgroundColor = "F88"

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
