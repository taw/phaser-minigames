Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

randint = (a,b) ->
  a + Math.floor(Math.random() * (b-a+1))

class Cell
  constructor: (x,y,c) ->
    @x = x
    @y = y
    @c = c
    @revealed = false
    @grid = game.add.graphics(@x, @y)
    @grid.lineStyle(2, 0x000000, 1)
    @grid.drawPolygon(
      -10, -10,
      -10,  10,
       10,  10,
       10, -10,
      -10, -10,
    )

class Board
  constructor: ->
    @size_x = 10
    @size_y = 10
    @mines = 10
    @content = ((null for y in [0...@size_y]) for x in [0...@size_x])
    @setup_mines()
    @setup_numbers()
    @setup_grid()

  setup_grid: ->
    @grid = for x in [0...@size_x]
      for y in [0...@size_y]
        loc_x = (size_x/2 - 90) + 20 * x
        loc_y = (size_y/2 - 90) + 20 * y
        new Cell(loc_x,loc_y,@content[x][y])

  setup_mines: ->
    mines_left = @mines
    while mines_left > 0
      x = randint(0, @size_x-1)
      y = randint(0, @size_y-1)
      if @content[x][y] == null
        @content[x][y] = "X"
        mines_left -= 1

  mines_near_xy: (x, y) ->
    total = 0
    for xx in [x-1, x, x+1]
      continue if xx < 0 or xx >= @size_x
      for yy in [y-1, y, y+1]
        continue if yy < 0 or yy >= @size_y
        total += 1 if @content[xx][yy] == "X"
    total

  setup_numbers: ->
    for x in [0...@size_x]
      for y in [0...@size_y]
        continue if @content[x][y] == "X"
        @content[x][y] = @mines_near_xy(x, y)

class GameState
  constructor: ->
    null

  update: ->
    null

  create: ->
    @game.stage.backgroundColor = "8F8"
    @board = new Board

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
