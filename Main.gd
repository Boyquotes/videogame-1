extends Node2D

@onready var player: RigidBody2D = $Player
@onready var platforms: Node2D = $Platforms
@onready var background: Node2D = $SpaceBackground/SpaceBackground
@onready var background2: Node2D = $SpaceBackground/SpaceBackground2
@onready var death_area: Area2D = $DeathArea
@onready var border_right_screen_area: Area2D = $BorderRightScreenArea
@onready var ui: Control = $UI
@onready var ui_info := $UI/PanelContainer/BoxContainer/VBoxContainer/HBoxContainer/Info
@onready var timer := $Timer
@onready var retry_btn := $UI/PanelContainer/BoxContainer/VBoxContainer/HBoxContainer2/Button


func _ready():
	set_all_processes(false)
	death_area.body_exited.connect(_on_exited_death_area)
	border_right_screen_area.area_entered.connect(_on_entered_screen_area)
	timer.timeout.connect(_on_timer_timeout)
	retry_btn.pressed.connect(_on_retry_btn_pressed)
	timer.start()

func _process(_delta):
	pass
	
func start_game() -> void:
	ui.hide()
	set_all_processes(true)

func finish_game() -> void:
	ui_info.text = "Game Over"
	ui.show()
	retry_btn.show()
	set_all_processes(false)
	
func _on_exited_death_area(body: Node) -> void:
	finish_game()
	
func _on_entered_screen_area(body: Node) -> void:
	var last_platform = body.get_parent()
	var new_platform = preload("res://Environment/TriplePlatform.tscn").instantiate()
	new_platform.position = last_platform.get_position() + Vector2(500, 0)
	platforms.add_child(new_platform)
	
	
func _on_timer_timeout() -> void:
	start_game()
	
func _on_retry_btn_pressed() -> void:
	get_tree().reload_current_scene()

func set_all_processes(enable: bool) -> void:
	player.set_process(enable)
	platforms.set_process(enable)
	background.set_process(enable)
	background2.set_process(enable)
	set_process(enable)
