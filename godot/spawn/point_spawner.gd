extends Node2D


@export var spawn_scene:PackedScene


@onready var timer: Timer = $Timer


var markers:Array[Marker2D]


func _ready() -> void:
	timer.timeout.connect(spawn)
	randomize()
	for child in get_children():
		if child is Marker2D:
			markers.append(child)
	

func spawn() -> void:
	var random_position = markers.pick_random().global_position
	var spawn_instance = spawn_scene.instantiate()
	spawn_instance.global_position = random_position
	add_child(spawn_instance)
	

