extends Sprite2D

const VELOCITY: float = -1.5
var background_texture_width: float = 0


func _ready():
	background_texture_width = texture.get_size().x * scale.x
	
func _process(delta) -> void:
	position.x += VELOCITY
	if position.x < -background_texture_width:
		position.x += background_texture_width * 2
