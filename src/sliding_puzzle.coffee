Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight


shuffle = (a) ->
  i = a.length
  while --i > 0
    j = ~~(Math.random() * (i + 1))
    t = a[j]
    a[j] = a[i]
    a[i] = t
  a

class Tile
  constructor: (x,y,c) ->
    @c = c
    @bg = game.add.graphics(x, y)
    @bg.lineStyle(2, 0x000000, 1)
    @bg.drawPolygon(
      -96, -54,
      -96,  54,
       96,  54,
       96, -54,
      -96, -54,
    )
    if c == 15
      @tile = game.add.text(x,y,"")
    else
      @tile = game.add.sprite(x, y, "tile#{c}")
      @tile.height = 108
      @tile.width = 192
    @tile.anchor.setTo(0.5, 0.5)

class Board
  constructor: ->
    @size_x = 4
    @size_y = 4
    tiles = shuffle([0..15])
    @content = ((tiles.pop() for y in [0...@size_y]) for x in [0...@size_x])
    @setup_grid()
    @status = "ready"

  setup_grid: ->
    @grid = for x in [0...@size_x]
      for y in [0...@size_y]
        loc_x = (size_x/2 - 192*1.5) + 192 * x
        loc_y = (size_y/2 - 108*1.5) + 108 * y
        new Tile(loc_x,loc_y,@content[x][y])

  flip_cells: (a,b) ->
    [a.c, b.c] = [b.c, a.c]
    [a.tile, b.tile] = [b.tile, a.tile]
    [a.tile.x, a.tile.y, b.tile.x, b.tile.y] = [b.tile.x, b.tile.y, a.tile.x, a.tile.y]

  click_cell: (x,y) ->
    # check 4 surrounding tiles
    for [xx,yy] in [[x-1,y], [x+1,y], [x,y-1], [x,y+1]]
      continue if xx < 0 or yy < 0 or xx >= @size_x or yy >= @size_y
      if @grid[xx][yy].c == 15
        @flip_cells(@grid[x][y], @grid[xx][yy])
        @check_if_completed()
        return true
    false

  check_if_completed: (x,y) ->
    if JSON.stringify(((cell.c for cell in row) for row in @grid)) == JSON.stringify([[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]])
      @completedText = game.add.text(16, 16, 'Completed in #{@score} moves!', { fontSize: '32px', fill: '#fff' })


class GameState
  constructor: ->
    null

  preload: ->
    for i in [0..15]
      @game.load.image("tile#{i}", "/images/sliding_puzzle/tile#{i}.jpg")

  update: ->
    @scoreText.text = "Clicks: #{@score}"

  click: (x,y) ->
    x = Math.round((x - size_x / 2 + 192*1.5) / 192)
    y = Math.round((y - size_y / 2 + 108*1.5) / 108)
    if x >= 0 and x <= @board.size_x-1 and y >= 0 and y <= @board.size_y-1
      if @board.click_cell(x,y)
        @score += 1

  create: ->
    @score = 0
    @scoreText = game.add.text(16, 16, '', { fontSize: '32px', fill: '#fff' })
    @game.stage.backgroundColor = "F88"
    @board = new Board
    @game.input.onTap.add =>
      @click(
        @game.input.activePointer.worldX,
        @game.input.activePointer.worldY,
      )


game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
