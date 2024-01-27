extends CharacterBody2D

@export var ACCELERATION = 1550
@export var CHARGING_ACCELERATION = ACCELERATION * 2
@export var FRICTION = 770
@export var MAX_SPEED = 275


@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var emotion_detector: Area2D = $EmotionDetector
@onready var receptor_detector: Area2D = $ReceptorDetector
@onready var collectors: Array[Node] = $Collectors.get_children()


var input_vector = Vector2.ZERO
var emotions:Array[int]= []

func _ready() -> void:
	emotion_detector.body_entered.connect(_on_emotion_collected)
	receptor_detector.body_entered.connect(_on_receptor_touched)


func _on_receptor_touched(receptor:Receptor) -> void:
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
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
