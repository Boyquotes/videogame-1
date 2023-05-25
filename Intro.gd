extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# get_tree().change_scene_to_file("res://Menu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_skip_btn_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
