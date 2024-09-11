extends Node

var lives = 3
var score = 0
var game_started = false

var hyper_mode = false

signal game_start()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		game_started = true
		game_start.emit()
		
	if lives <= 0:
		game_started = false
		lives = 3
		score = 0 
	pass

func screen_shake():
	#screen shake with tweens
	var camera = get_viewport().get_camera_2d()
	var tween = create_tween()
	tween.tween_property(camera, "offset", Vector2(50, 50), 0.1)
	tween.tween_property(camera, "offset", Vector2(-50, -50), 0.1)
	tween.tween_property(camera, "offset", Vector2(0, 0), 0.1)