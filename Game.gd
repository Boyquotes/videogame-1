extends Node2D

@onready var player: RigidBody2D = $Player
@onready var platforms: Node2D = $Platforms
@onready var background: Node2D = $SpaceBackground/SpaceBackground
@onready var background2: Node2D = $SpaceBackground/SpaceBackground2
@onready var death_area: Area2D = $DeathArea
@onready var border_right_screen_area: Area2D = $BorderRightScreenArea
@onready var ui := $UI
@onready var ui_info := $UI/PanelContainer/MainContainer/Info
@onready var buttons := $UI/PanelContainer/MainContainer/Buttons
@onready var timer := $Timer

var DISPLAY_WIDTH := 1920
const GRID_SIZE := 32
const MIN_PLATFORM_Y_POS := 256
const MAX_PLATFORM_Y_POS := 928
const MIN_PLATFORM_X_OFFSET := 96
const MAX_PLATFORM_X_OFFSET := 192


var platform_scenes := [
	preload("res://Environment/SinglePlatform.tscn"),
	preload("res://Environment/DoublePlatform.tscn"),
	preload("res://Environment/TriplePlatform.tscn"),
	]


func _ready():
	set_all_processes(false)
	_initialize_environment()
	death_area.body_exited.connect(_on_exited_death_area)
	border_right_screen_area.area_entered.connect(_on_platform_entered_screen_area)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _process(_delta):
	pass


func start_game() -> void:
	ui.hide()
	set_all_processes(true)


func finish_game() -> void:
	ui_info.text = "Game Over"
	ui.show()
	buttons.show()
	set_all_processes(false)


func _on_exited_death_area(body: Node) -> void:
	finish_game()


func _on_platform_entered_screen_area(body: Node) -> void:
	var last_platform = body.get_parent()
	_generate_new_platform(last_platform)


func _generate_new_platform(last_platform: Node) -> Node:
	var last_platform_position = last_platform.get_position()
	var last_platform_width = _get_platform_width(last_platform)
	var new_platform = platform_scenes[randi() % 3].instantiate() # We only have 3 different platforms
	var new_platform_x_distance_grid_units := randi_range(3, 6)
	var new_platform_x_distance = new_platform_x_distance_grid_units * GRID_SIZE # Calculate distance based on grid so we can match Y offset
	var new_platform_x_offset = last_platform_position.x + last_platform_width + new_platform_x_distance
	var new_platform_y_offset = _generate_new_platform_y_offset(last_platform_position.y, new_platform_x_distance_grid_units) # The y offset will depend on the x offset
	new_platform.position = Vector2(new_platform_x_offset, new_platform_y_offset)
	platforms.call_deferred("add_child", new_platform)
	return new_platform


func _generate_new_platform_y_offset(last_platform_y_position, new_platform_x_distance_grid_units: int) -> int:
	var should_generate_platform_above: bool
	
	if last_platform_y_position <= 256:
		should_generate_platform_above = not randi_range(1,2) == 1
	else:
		should_generate_platform_above = not randi_range(1,10) == 1 # 90% Chances the platform will be above the previous one.
	
	if not should_generate_platform_above:
		return randi_range(last_platform_y_position/GRID_SIZE, MAX_PLATFORM_Y_POS/GRID_SIZE) * GRID_SIZE
		
	if new_platform_x_distance_grid_units <= 5:
		return randi_range(-2, 0) * GRID_SIZE + last_platform_y_position
		
	if new_platform_x_distance_grid_units == 6:
		return randi_range(-1, 0) * GRID_SIZE + last_platform_y_position
		
	return last_platform_y_position


func _on_timer_timeout() -> void:
	start_game()


func set_all_processes(enable: bool) -> void:
	player.set_process(enable)
	platforms.set_process(enable)
	background.set_process(enable)
	background2.set_process(enable)
	set_process(enable)


func _get_platform_width(platform: Node) -> int:
	# We are using the collision shape to get the size and not the sprite because we have some platforms composed by more than one sprite.
	var platform_collision_shape_size = platform.get_node("CollisionShape2D").shape.get_size()
	# The collision shape is 64px wider than the sprite. Also everything is scaled down 0.5
	return (platform_collision_shape_size.x - 64) / 2


func _initialize_environment() -> void:
	_generate_initial_platforms()


func _generate_initial_platforms() -> void:
	var new_platform = platform_scenes[randi() % 3].instantiate()
	new_platform.position = Vector2(randi_range(3, 6) * GRID_SIZE, randi_range(8, 29) * GRID_SIZE)
	platforms.call_deferred("add_child", new_platform)
	_position_player(new_platform) # This logic should be extracted
	while new_platform.position.x + _get_platform_width(new_platform) <= DISPLAY_WIDTH:
		new_platform = _generate_new_platform(new_platform)


func _position_player(platform: Node) -> void:
	var platform_width = _get_platform_width(platform)
	player.position = Vector2(platform.position.x + (platform_width / 2), platform.position.y - player.get_node("CollisionShape2D").shape.get_size().y)


func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://Menu.tscn")


func _on_retry_pressed():
	get_tree().reload_current_scene()
