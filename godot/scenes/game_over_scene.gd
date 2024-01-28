extends Node2D


const IngameScene = preload("res://scenes/ingame_scene.tscn")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey or event is InputEventJoypadButton:
		get_tree().change_scene_to_packed(IngameScene)
		
