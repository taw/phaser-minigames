Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  preload: ->
    @game.load.image("cat", "/images/cat_images/cat17.png")
    @game.load.image("platform", "/images/grass_platform.png")

  update: ->
    game.physics.arcade.collide(@player, @platform)
    @player.body.velocity.x = 0
    if @cursors.left.isDown
      @player.body.velocity.x = -150
    if @cursors.right.isDown
      @player.body.velocity.x = 150
    if @jumpButton.isDown # && @player.body.onFloor()
      @player.body.velocity.y = -250

  create: ->
    @game.stage.backgroundColor = "8F8"
    game.physics.startSystem(Phaser.Physics.ARCADE)
    @cursors = game.input.keyboard.createCursorKeys()
    @jumpButton = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)

    @player = game.add.sprite(size_x/2, size_y-100, 'cat')
    @player.anchor.set(0.5)
    @player.height = 64
    @player.width = 64
    game.physics.enable(@player, Phaser.Physics.ARCADE)

    @player.body.gravity.y = 250
    @player.body.bounce.y = 0.2
    @player.body.collideWorldBounds = true

    @platform = game.add.sprite(200, size_y-100, 'platform')
    @platform.height = 40
    @platform.width = 200
    @platform.anchor.set(0.5)
    game.physics.enable(@platform, Phaser.Physics.ARCADE)
    @platform.body.immovable = true

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
