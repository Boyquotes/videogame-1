extends StaticBody2D

const VELOCITY: float = 2.0

func _ready():
	pass # Replace with function body.


func _process(delta):
	position.x -= VELOCITY
