extends Node2D


@export var MAX_SPEED := 10
@export var MIN_COLLECT_DISTANCE := 4


var target_receptor:Receptor
var target_position:Vector2


func _ready() -> void:
	target_position = target_receptor.get_receiving_position()


func _physics_process(delta: float) -> void:
	var distance = target_position - global_position
	var velocity = distance.normalized() * MAX_SPEED
	position += velocity
	
	if distance.length() < MIN_COLLECT_DISTANCE:
		target_receptor.deliver()
		queue_free()

