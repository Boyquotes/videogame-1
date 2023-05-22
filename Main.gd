extends Node2D

var main_menu := preload("res://Menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu.instantiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
