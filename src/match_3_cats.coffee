Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

randint = (a,b) ->
  a + Math.floor(Math.random() * (b-a+1))

class Board
  constructor: ->
    @size_x = 8
    @size_y = 8
    @grid = for x in [0...@size_x]
      for y in [0...@size_y]
        loc_x = size_x/2 + 80*(x-3.5)
        loc_y = size_y/2 + 80*(y-3.5)
        c = randint(0, 6)
        tile = game.add.sprite(loc_x, loc_y, "cat#{c}")
        tile.anchor.setTo(0.5, 0.5)
        tile.height = 64
        tile.width = 64
        tile

class GameState
  preload: ->
    for i,j in [3, 4, 11, 13, 17, 18, 20]
      @game.load.image("cat#{j}", "/images/cat_images/cat#{i}.png")

  rotation_position: ->
    mx = @game.input.activePointer.worldX
    my = @game.input.activePointer.worldY
    cx = Math.floor(((mx - size_x/2) / 80) + 3.5)
    cy = Math.floor(((my - size_y/2) / 80) + 3.5)
    cx = game.math.clamp(cx, 0, 6)
    cy = game.math.clamp(cy, 0, 6)
    [cx, cy]

  update: ->
    [cx, cy] = @rotation_position()
    @rotation.x = size_x/2 + 80*(cx-3)
    @rotation.y = size_y/2 + 80*(cy-3)
    # c = randint(0, 6)
    # @board.grid[0][0].loadTexture("cat#{c}")

  create: ->
    @game.stage.backgroundColor = "F88"
    @board = new Board()

    @rotation = game.add.graphics(0, 0)
    @rotation.lineStyle(5, 0xFF0000)
    @rotation.drawCircle(0, 0, 160)


game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
