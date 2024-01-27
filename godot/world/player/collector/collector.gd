class_name Collector extends Node2D

## Toggle this property to charge up this collector.
@export var emotion:Emotion.EmotionType:
	set(e):
		emotion = e
		if charge != null:
			charge.visible = true
			if emotion == Emotion.EmotionType.HAPPINESS:
				charge.animation = "happiness"
			if emotion == Emotion.EmotionType.SADNESS:
				charge.animation = "sadness"

@onready var charge: AnimatedSprite2D = $Charge


func clear() -> void:
	charge.visible = false
	

func is_charged() -> bool:
	return charge.visible == true
