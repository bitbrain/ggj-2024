extends Node2D


@onready var collision_polygons = $Collisions.get_children()
@onready var shadows = $Shadows


func _ready() -> void:
	_generate_occluders()


func _generate_occluders() -> void:
	for collision:CollisionPolygon2D in collision_polygons:
		var light_2d_occluder = LightOccluder2D.new()
		var occlusion_polygon = OccluderPolygon2D.new()
		occlusion_polygon.polygon = collision.polygon
		light_2d_occluder.occluder = occlusion_polygon
		shadows.add_child(light_2d_occluder)
