Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  constructor: ->
    null

  hour_text: (i) ->
    x = size_x / 2 + 200 * Math.sin(Math.PI*2 * i / 24)
    y = size_y / 2 - 200 * Math.cos(Math.PI*2 * i / 24)
    label = ""+i
    text = new Phaser.Text(game, x, y, label, { font: "20px Arial", fill: "#ff0044", align: "center" })
    text.anchor.set(0.5)
    text.angle = 360 * i / 24
    game.add.existing(text);

  minute_text: (i) ->
    x = size_x / 2 + 300 * Math.sin(Math.PI*2 * i / 60)
    y = size_y / 2 - 300 * Math.cos(Math.PI*2 * i / 60)
    label = ""+i
    text = new Phaser.Text(game, x, y, label, { font: "20px Arial", fill: "#ff0044", align: "center" })
    text.anchor.set(0.5)
    text.angle = 360 * i / 60
    game.add.existing(text);

  second_text: (i) ->
    x = size_x / 2 + 400 * Math.sin(Math.PI*2 * i / 60)
    y = size_y / 2 - 400 * Math.cos(Math.PI*2 * i / 60)
    label = ""+i
    text = new Phaser.Text(game, x, y, label, { font: "20px Arial", fill: "#ff0044", align: "center" })
    text.anchor.set(0.5)
    text.angle = 360 * i / 60
    game.add.existing(text);

  update: ->
    null

  create: ->
    @game.stage.backgroundColor = "88F"
    @hours   = (@hour_text(i) for i in [0..23])
    @minutes = (@minute_text(i) for i in [0..59])
    @seconds = (@second_text(i) for i in [0..59])

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
