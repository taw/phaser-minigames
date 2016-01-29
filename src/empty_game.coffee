Phaser = window.Phaser
game_state = null
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  constructor: ->
    null

  update: (dt) ->
    null

update = ->
  game_state.update(game.time.elapsed/1000.0)

create = ->
  game.stage.backgroundColor = "88F"

game_state = new GameState
game = new Phaser.Game(size_x, size_y, Phaser.AUTO, '', { create: create, update: update })
