Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  constructor: ->
    null

  new_cell: (x,y) ->
    text = new Phaser.Text(game, size_x/2 - 200 + 200*x, size_y/2 - 200 + 200*y, "",
      { font: "64px Arial", fill: "000", align: "center" })
    text.anchor.set(0.5)
    game.add.existing(text)
    text

  update: ->
    for y in [0..2]
      for x in [0..2]
        @content_cells[y][x].text = @content[y][x]

  create: ->
    @winner = null
    @content = (("?" for x in [0..2]) for y in [0..2])
    @content_cells = ((@new_cell(x, y) for x in [0..2]) for y in [0..2])
    @game.stage.backgroundColor = "F88"
    @grid = game.add.graphics(size_x / 2, size_y / 2)
    @grid.lineStyle(5, "red")
    @grid.moveTo(-300,  100)
    @grid.lineTo( 300,  100)
    @grid.moveTo(-300, -100)
    @grid.lineTo( 300, -100)
    @grid.moveTo(-100, -300)
    @grid.lineTo(-100,  300)
    @grid.moveTo( 100, -300)
    @grid.lineTo( 100,  300)
    @grid.endFill()
    @game.input.onTap.add =>
      @click @game.input.activePointer.worldX, @game.input.activePointer.worldY

  click: (x,y) ->
    x = Math.floor( (x - size_x / 2 + 300) / 200 )
    y = Math.floor( (y - size_y / 2 + 300) / 200 )
    if x >= 0 and x <= 2 and y >= 0 and y <= 2
      @click_cell(x,y)

  check_who_won: ->
    lines = [
      [[0,0], [1,0], [2,0]],
      [[0,1], [1,1], [2,1]],
      [[0,2], [1,2], [2,2]],
      [[0,0], [0,1], [0,2]],
      [[1,0], [1,1], [1,2]],
      [[2,0], [2,1], [2,2]],
      [[0,0], [1,1], [2,2]],
      [[2,0], [1,1], [0,2]],
    ]
    for line in lines
      values = (@content[y][x] for [x,y] in line)
      if JSON.stringify(values) == JSON.stringify(["X", "X", "X"])
        @winner = "X"
      if JSON.stringify(values) == JSON.stringify(["O", "O", "O"])
        @winner = "O"

  ai_movement: ->
    return if @winner != null
    # TODO
    null

  click_cell: (x,y) ->
    return if @winner != null
    if @content[y][x] == "?"
      @content[y][x] = "X"
      @check_who_won()
      @ai_movement()

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
