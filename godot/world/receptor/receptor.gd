class_name Receptor extends StaticBody2D


signal emotions_received(emotions:Array[int])


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func deliver(emotions:Array[int]) -> void:
	audio_stream_player_2d.play()
	emotions_received.emit(emotions)
