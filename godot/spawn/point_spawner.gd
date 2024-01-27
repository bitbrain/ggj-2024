extends Node2D


const EmotionScene = preload("res://world/emotion/emotion.tscn")
const Emotions = [Emotion.EmotionType.HAPPINESS, Emotion.EmotionType.SADNESS]

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
	var spawn_instance = EmotionScene.instantiate() as Emotion
	spawn_instance.emotion_type = Emotions.pick_random()
	spawn_instance.global_position = random_position
	add_child(spawn_instance)
	

