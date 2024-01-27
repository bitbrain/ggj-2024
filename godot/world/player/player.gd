extends CharacterBody2D

@export var ACCELERATION = 1550
@export var CHARGING_ACCELERATION = ACCELERATION * 2
@export var FRICTION = 770
@export var MAX_SPEED = 275


@onready var endorphin_detector: Area2D = $EndorphinDetector
@onready var endorphin_counter: Label = $EndorphinCounter


var input_vector = Vector2.ZERO
var endorphins := 0:
	set(e):
		endorphins = e
		if endorphin_counter != null:
			endorphin_counter.text = str(endorphins)


func _ready() -> void:
	endorphin_detector.body_entered.connect(_on_endorphin_collected)


func _on_endorphin_collected(endorphin:Endorphin) -> void:
	endorphins += 1
	# TODO: animate absorbtion process
	endorphin.queue_free()


func move(input_vector:Vector2) -> void:
	self.input_vector = input_vector.normalized()


func _physics_process(delta: float) -> void:
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
