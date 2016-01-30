Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  preload: ->
    @game.load.image("cat", "/images/cat_images/cat17.png")

  update: ->
    @player.body.velocity.x = 0
    if @cursors.left.isDown
      @player.body.velocity.x = -150
    if @cursors.right.isDown
      @player.body.velocity.x = 150
    if @jumpButton.isDown && @player.body.onFloor()
      @player.body.velocity.y = -250

  create: ->
    @game.stage.backgroundColor = "8F8"
    game.physics.startSystem(Phaser.Physics.ARCADE)

    game.physics.arcade.gravity.y = 250

    @player = game.add.sprite(size_x/2, size_y/2, 'cat')
    @player.height = 64
    @player.width = 64
    game.physics.enable(@player, Phaser.Physics.ARCADE);

    @player.body.bounce.y = 0.5
    @player.body.collideWorldBounds = true
    # player.body.setSize(20, 32, 5, 16)

    @cursors = game.input.keyboard.createCursorKeys()
    @jumpButton = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
