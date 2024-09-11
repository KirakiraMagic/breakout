extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Lives: " + str(Global.lives) + "\n Score: " + str(Global.score)
	pass


func _on_out_of_bounds_body_entered(body):
	Global.lives -= 1
	$"../Timer".start()
	pass # Replace with function body.
