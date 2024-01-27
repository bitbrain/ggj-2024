class_name Receptor extends StaticBody2D


signal emotions_received(emotions:Array[int])


func deliver(emotions:Array[int]) -> void:
	emotions_received.emit(emotions)
