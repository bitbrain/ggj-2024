extends CharacterBody2D

@export var ACCELERATION = 1550
@export var CHARGING_ACCELERATION = ACCELERATION * 2
@export var FRICTION = 770
@export var MAX_SPEED = 275


var input_vector = Vector2.ZERO


func move(input_vector:Vector2) -> void:
	self.input_vector = input_vector.normalized()


func _physics_process(delta: float) -> void:
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
