extends RigidBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _ground_raycast = $GroundRaycast

var is_running: bool = false
var is_grounded: bool = false
var is_idle: bool = true

func _ready():
	_animated_sprite.play("idle")


func _process(delta):
	is_grounded = _ground_raycast.is_colliding()

	if is_grounded:
		is_running = true
		_animated_sprite.play("run")
	else:
		_animated_sprite.play("jump")
		
	
	if Input.is_action_just_pressed("jump") and is_grounded:
		apply_impulse(Vector2(0, -400))
		
func stop_animation():
	_animated_sprite.stop()
		


