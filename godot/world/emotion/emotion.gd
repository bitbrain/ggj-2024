@tool
class_name Emotion extends CharacterBody2D


const COLOR_HAPPINESS = Color("ffe5c1")
const COLOR_SADNESS = Color("b6f7fc")

enum EmotionType {
	HAPPINESS = 1,
	SADNESS = -1
}

@export var emotion_type:EmotionType = EmotionType.HAPPINESS:
	set(et):
		emotion_type = et
		if emotion_sprite != null:
			if emotion_type == EmotionType.HAPPINESS:
				emotion_sprite.animation = "happiness"
				point_light_2d.color = COLOR_HAPPINESS
			if emotion_type == EmotionType.SADNESS:
				emotion_sprite.animation = "sadness"
				point_light_2d.color = COLOR_SADNESS
		

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var emotion_sprite: AnimatedSprite2D = $EmotionSprite


func _ready() -> void:
	# enforce setget
	self.emotion_type = emotion_type
