extends PointLight2D


@export var animation_strength := 16

var original_pos:Vector2


func _ready() -> void:
	original_pos = position
	_animate()


func _animate() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	var base_vector = Vector2(animation_strength, 0.0)
	var rotated = base_vector.rotated(randf_range(deg_to_rad(0), deg_to_rad(360)))
	tween.tween_property(self, "position", original_pos + rotated, 0.2)\
	.finished.connect(_animate)
