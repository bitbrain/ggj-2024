class_name Receptor extends StaticBody2D


signal emotions_received


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var receive_positions: Array[Node] = $ReceivePositions.get_children()


func deliver() -> void:
	audio_stream_player_2d.play()
	emotions_received.emit()


func get_receiving_position() -> Vector2:
	var random_marker = receive_positions.pick_random()
	return random_marker.global_position
