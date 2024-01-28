class_name PointSpawner extends Node2D


const EmotionScene = preload("res://world/emotion/emotion.tscn")
const Emotions = [Emotion.EmotionType.HAPPINESS, Emotion.EmotionType.HAPPINESS, Emotion.EmotionType.HAPPINESS, Emotion.EmotionType.SADNESS]


## The number of initial entities to spawn and also the maximum number
@export var spawn_amount := 8


@onready var timer: Timer = $Timer


var markers:Array[Marker2D]


func _ready() -> void:
	timer.timeout.connect(spawn)
	randomize()
	for child in get_children():
		if child is Marker2D:
			markers.append(child)
			
	for index in range(0, spawn_amount):
		spawn()


func start_spawning() -> void:
	timer.start()
	

func spawn() -> void:
	var random_position = markers.pick_random().global_position
	var spawn_instance = EmotionScene.instantiate() as Emotion
	spawn_instance.emotion_type = Emotions.pick_random()
	spawn_instance.global_position = random_position
	add_child(spawn_instance)
	
	var emotion_count = 0
	for child in get_children():
		if child is Emotion:
			emotion_count += 1
	if emotion_count == spawn_amount:
		timer.stop()
	

