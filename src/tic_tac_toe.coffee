Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

randint = (a,b) ->
  a + Math.floor(Math.random() * (b-a+1))

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
    switch @winner
      when "X"
        @winnerText.text = "X won"
      when "O"
        @winnerText.text = "O won"
      when "Draw"
        @winnerText.text = "DRAW"
      else
        @winnerText.text = "Game goes on"

  create: ->
    @winner = null
    @winnerText = game.add.text(16, 16, '', { fontSize: '32px', fill: '#fff' })
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
    if @winner == null
      x = Math.floor( (x - size_x / 2 + 300) / 200 )
      y = Math.floor( (y - size_y / 2 + 300) / 200 )
      if x >= 0 and x <= 2 and y >= 0 and y <= 2
        @click_cell(x,y)
    else
      @state.restart()

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
    if @winner == null
      @winner = "Draw"
      for y in [0..2]
        for x in [0..2]
          if @content[y][x] == "?"
            @winner = null

  ai_movement: ->
    return if @winner != null
    while true
      x = randint(0,2)
      y = randint(0,2)
      if @content[y][x] == "?"
        @content[y][x] = "O"
        break

  click_cell: (x,y) ->
    return if @winner != null
    if @content[y][x] == "?"
      @content[y][x] = "X"
      @check_who_won()
      @ai_movement()
      @check_who_won()

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
