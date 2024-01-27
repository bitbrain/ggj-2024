extends CharacterBody2D

@export var ACCELERATION = 1550
@export var CHARGING_ACCELERATION = ACCELERATION * 2
@export var FRICTION = 770
@export var MAX_SPEED = 275


@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var emotion_detector: Area2D = $EmotionDetector
@onready var collectors: Array[Node] = $Collectors.get_children()


var input_vector = Vector2.ZERO
var emotions:Array[int]= []
			
var happiness := 0:
	set(h):
		happiness = h
		if player_sprite != null:
			if happiness > 3:
				player_sprite.animation = "happy"
			elif happiness < 0:
				player_sprite.animation = "sad"
			else:
				player_sprite.animation = "neutral"

func _ready() -> void:
	self.happiness = 0
	emotion_detector.body_entered.connect(_on_emotion_collected)


func _on_emotion_collected(emotion:Emotion) -> void:
	emotions.append(emotion.emotion_type)

	# TODO: animate absorbtion process
	emotion.queue_free()
	
	if emotions.size() == collectors.size():
		emotions.clear()
		for index in range(0, collectors.size()):
			var collector = collectors[index] as Collector
			collector.clear()
		# TODO: figure out way to drive
		# emotions.
		happiness += 1
	else:
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
