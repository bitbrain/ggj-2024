extends Node2D


const IngameScene = preload("res://scenes/ingame_scene.tscn")


@onready var timer: Timer = $Timer


var can_move_on = false


func _ready() -> void:
	timer.timeout.connect(_move_on)
	
	
func _move_on() -> void:
	can_move_on = true


func _input(event: InputEvent) -> void:
	if can_move_on and event is InputEventMouseButton or event is InputEventKey or event is InputEventJoypadButton:
		get_tree().change_scene_to_packed(IngameScene)
		
