extends Node2D


const VELOCITY: float = 2.0

func _ready():
	pass


func _process(delta):
	position.x -= VELOCITY
	
