class_name Collector extends Node2D

## Toggle this property to charge up this collector.
@export var charged:bool = false:
	set(c):
		charged = c
		if charge != null:
			charge.visible = charged

@onready var charge: Sprite2D = $Charge


func _ready() -> void:
	charge.visible = charged

