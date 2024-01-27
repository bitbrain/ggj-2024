@tool
class_name Collector extends Node2D

## Toggle this property to charge up this collector.
@export var charged:bool = false:
	set(c):
		charged = c
		if charge != null:
			charge.visible = charged
			point_light_2d.visible = charged

@onready var charge: Sprite2D = $Charge
@onready var point_light_2d: PointLight2D = $PointLight2D


func _ready() -> void:
	charge.visible = charged
	point_light_2d.visible = charged

