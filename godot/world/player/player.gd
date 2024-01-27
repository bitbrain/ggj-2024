extends CharacterBody2D

@export var ACCELERATION = 1550
@export var CHARGING_ACCELERATION = ACCELERATION * 2
@export var FRICTION = 770
@export var MAX_SPEED = 275


@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var endorphin_detector: Area2D = $EndorphinDetector
@onready var collectors: Array[Node] = $Collectors.get_children()


var input_vector = Vector2.ZERO
var endorphins := 0:
	set(e):
		endorphins = e
		if collectors != null:
			for index in range(0, collectors.size()):
				var collector = collectors[index] as Collector
				collector.charged = index < endorphins
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
	endorphin_detector.body_entered.connect(_on_endorphin_collected)


func _on_endorphin_collected(endorphin:Endorphin) -> void:
	endorphins += 1
	# TODO: animate absorbtion process
	endorphin.queue_free()
	
	if endorphins == collectors.size():
		endorphins = 0
		happiness += 1

func move(input_vector:Vector2) -> void:
	self.input_vector = input_vector.normalized()


func _physics_process(delta: float) -> void:
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
