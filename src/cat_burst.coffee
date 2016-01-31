Phaser = window.Phaser
size_x = window.innerWidth
size_y = window.innerHeight

class GameState
  update: ->
    null

  preload: ->
    game.load.image('cat', '/images/cat-cupid-love-icon2.png')

  create: ->
    game.stage.backgroundColor = "8FA"
    game.physics.startSystem(Phaser.Physics.ARCADE)

    @emitter = game.add.emitter(0, 0, 1000)
    @emitter.makeParticles('cat')
    @emitter.gravity = 200

    game.input.onDown.add (pointer) =>
      @emitter.x = pointer.x
      @emitter.y = pointer.y

      # The first parameter sets the effect to "explode" which means all particles are emitted at once
      # The second gives each particle a 2000ms lifespan
      # The third is ignored when using burst/explode mode
      # The final parameter (10) is how many particles will be emitted in this single burst
      @emitter.start true, 5000, null, 10

game = new Phaser.Game(size_x, size_y)
game.state.add("Game", GameState, true)
