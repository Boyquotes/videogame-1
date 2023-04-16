extends Node2D

@onready var player: RigidBody2D = $Player
@onready var platforms: Node2D = $Platforms
@onready var background: Node2D = $SpaceBackground/SpaceBackground
@onready var background2: Node2D = $SpaceBackground/SpaceBackground2
@onready var death_area: Area2D = $DeathArea

func _ready():
	death_area.body_exited.connect(_on_exited_death_area)


func _process(delta):
	pass

func finish_game() -> void:
	set_all_processes(false)

func _on_exited_death_area(body: Node) -> void:
	finish_game()

func set_all_processes(enable: bool) -> void:
	player.set_process(enable)
	platforms.set_process(enable)
	background.set_process(enable)
	background2.set_process(enable)
	set_process(enable)
