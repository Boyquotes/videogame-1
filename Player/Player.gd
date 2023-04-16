extends RigidBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _ground_raycast = $GroundRaycast

var is_running: bool = true
var is_jumping: bool = false

func _ready():
	pass


func _process(delta):
	is_jumping = not _ground_raycast.is_colliding()

	if not is_jumping:
		is_running = true
		_animated_sprite.play("run")
	else:
		_animated_sprite.play("jump")
	
	if Input.is_action_just_pressed("jump") and not is_jumping:
		apply_impulse(Vector2(0, -400))


