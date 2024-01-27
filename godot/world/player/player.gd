extends CharacterBody2D

@export var ACCELERATION = 1550
@export var CHARGING_ACCELERATION = ACCELERATION * 2
@export var FRICTION = 770
@export var MAX_SPEED = 275


@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var emotion_detector: Area2D = $EmotionDetector
@onready var receptor_detector: Area2D = $ReceptorDetector
@onready var collectors: Array[Node] = $Collectors.get_children()
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


var input_vector = Vector2.ZERO
var emotions:Array[int]= []

func _ready() -> void:
	emotion_detector.body_entered.connect(_on_emotion_collected)
	receptor_detector.body_entered.connect(_on_receptor_touched)
	
	navigation_agent_2d.path_desired_distance = 8.0
	navigation_agent_2d.target_desired_distance = 8.0
	navigation_agent_2d.debug_enabled = false
	
	
func _unhandled_input(event):
	if not event.is_action_pressed("click"):
		return
	set_target_position(get_global_mouse_position())


func set_target_position(target_position:Vector2) -> void:
	navigation_agent_2d.target_position = target_position


func _on_receptor_touched(receptor:Receptor) -> void:
	if emotions.is_empty():
		return
	receptor.deliver(emotions.duplicate())
	emotions.clear()
	for index in range(0, collectors.size()):
		var collector = collectors[index] as Collector
		collector.clear()


func _on_emotion_collected(emotion:Emotion) -> void:
	if emotions.size() < collectors.size():
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

