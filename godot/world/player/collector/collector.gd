class_name Collector extends Node2D

## Toggle this property to charge up this collector.
@export var emotion:Emotion.EmotionType:
	set(e):
		emotion = e
		if charge != null:
			charge.visible = true
			audio_player.play()

@onready var charge: AnimatedSprite2D = $Charge
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D



func clear() -> void:
	charge.visible = false
	

func is_charged() -> bool:
	return charge.visible == true
