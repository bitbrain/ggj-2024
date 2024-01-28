class_name Player extends CharacterBody2D


signal dead


const WorldCursor = preload("res://world/cursor/world_cursor.tscn")
const Transfer = preload("res://world/transfer/transfer.tscn")


@export var ACCELERATION = 1550
@export var CHARGING_ACCELERATION = ACCELERATION * 2
@export var FRICTION = 770
@export var MAX_SPEED = 275


@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var emotion_detector: Area2D = $EmotionDetector
@onready var receptor_detector: Area2D = $ReceptorDetector
@onready var collectors: Array[Node] = $Collectors.get_children()
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var hit_sound: AudioStreamPlayer2D = $HitSound


var input_vector = Vector2.ZERO
var emotions:Array[int]= []

func _ready() -> void:
	emotion_detector.body_entered.connect(_on_emotion_collected)
	receptor_detector.body_entered.connect(_on_receptor_touched)
	
	navigation_agent_2d.path_desired_distance = 8.0
	navigation_agent_2d.target_desired_distance = 8.0
	navigation_agent_2d.debug_enabled = false
	
	
func _input(event):
	if not event.is_action_pressed("click"):
		return
	set_target_position(get_global_mouse_position())


func set_target_position(target_position:Vector2) -> void:
	navigation_agent_2d.target_position = target_position
	var cursor = WorldCursor.instantiate()
	cursor.global_position = target_position
	get_parent().add_child(cursor)


func _on_receptor_touched(receptor:Receptor) -> void:
	if emotions.is_empty():
		return
	for index in range(0, collectors.size()):
		var collector = collectors[index] as Collector
		if collector.is_charged():
			var transfer_instance = Transfer.instantiate()
			transfer_instance.global_position = collector.global_position
			transfer_instance.target_receptor = receptor
			receptor.get_parent().add_child(transfer_instance)
			collector.clear()
	emotions.clear()


func _on_emotion_collected(emotion:Emotion) -> void:
	if emotion.emotion_type == Emotion.EmotionType.SADNESS:
		if not collectors.is_empty():
			var collector = collectors.pop_front()
			emotions.pop_front()
			collector.queue_free()
			emotion.queue_free()
			hit_sound.play()
			_queue_death_check.call_deferred()
	elif emotions.size() < collectors.size():
		emotions.append(emotion.emotion_type)
		emotion.queue_free()
		for index in range(0, emotions.size()):
			var collector = collectors[index] as Collector
			collector.emotion = emotions[index]
	

func move(input_vector:Vector2) -> void:
	self.input_vector = input_vector.normalized()


func _physics_process(delta: float) -> void:
	if input_vector != Vector2.ZERO:
		navigation_agent_2d.target_position = global_position
		navigation_agent_2d.get_next_path_position()
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	elif not navigation_agent_2d.is_navigation_finished():
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
		velocity = current_agent_position.direction_to(next_path_position) * MAX_SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()


func _queue_death_check() -> void:
	if collectors.is_empty():
		dead.emit()
