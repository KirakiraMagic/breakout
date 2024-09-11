extends CharacterBody2D

@onready var ball_sprite = $BallSprite
@onready var ripple = $Ripple
@onready var invis_time = $InvisTimer
@onready var background = $"../Background"

var hyper_mode = false
const PADDLE_WIDTH: float = 100.0

@export var speed : float = 300.0
var forward = Vector2(1.0,1.0).normalized()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	ball_sprite.visible = false
	ripple.visible = false
	Global.game_start.connect(_on_game_start)
	pass

func _on_game_start():
	ball_sprite.visible = true
	ripple.visible = false

func _physics_process(delta) -> void:
	if not Global.game_started:
		ball_sprite.visible = false
		ripple.visible = false
		visible = false
		return
	else:
		visible = true
	
	ball_sprite.look_at(forward+ball_sprite.global_position)
	var collision: KinematicCollision2D = move_and_collide(forward * speed * delta)
	if collision:
		forward = forward.bounce(collision.get_normal())
		if collision.get_collider().is_in_group("hurt_star"):
			Global.lives -= 1
			collision.get_collider().queue_free()
			if Global.lives <= 0:
				ball_sprite.visible = false
				ripple.visible = false
		if collision.get_collider().is_in_group("bricks"):
			Global.score += 10
			if hyper_mode: Global.screen_shake()
			if collision.get_collider().is_in_group("invisible_brick"):
				invis_time.start(1.0)
				ball_sprite.visible = false
				ripple.visible = true
			collision.get_collider().queue_free()
			if collision.get_collider().is_in_group("hyper_brick"):
				Engine.time_scale = 2.0
				hyper_mode = true
				print ("Hyper Mode!")
				#change background material parameter
				background.material.set_shader_parameter("star_brightness",1.0)

				get_tree().create_timer(5.0).timeout.connect(_on_hyper_timeout)
		if collision.get_collider().is_in_group("paddle"):
			var paddle_x = collision.get_collider().position.x - 50
			var pos_on_paddle = (position.x - paddle_x) / PADDLE_WIDTH
			print("Hit the Paddle! " + str(pos_on_paddle))
			var bounce_angle = lerp(-PI * 0.7, -PI * 0.3, pos_on_paddle)
			forward = Vector2.from_angle(bounce_angle)

func _on_hyper_timeout():
	Engine.time_scale = 1.0
	background.material.set_shader_parameter("star_brightness",0.02)
	hyper_mode = false

func _on_timer_timeout():
	ball_sprite.visible = true
	ripple.visible = false
	print("repositioned")
	position = Vector2(555,210)
	pass # Replace with function body.


func _on_invis_timer_timeout():
	ball_sprite.visible = true
	ripple.visible = false
	pass # Replace with function body.
