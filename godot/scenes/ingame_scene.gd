extends Node2D

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay
@onready var receptors: Array[Node] = $Receptors.get_children()


var emotional_state := 0


func _ready() -> void:
	fade_overlay.visible = true
	
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())
	
	pause_overlay.game_exited.connect(_save_game)
	
	for receptor:Receptor in receptors:
		receptor.emotions_received.connect(_on_emotions_received)

func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true
		
func _save_game() -> void:
	SaveGame.save_game(get_tree())
	
	
func _on_emotions_received(emotions:Array[int]) -> void:
	for emotion in emotions:
		emotional_state += emotion
		
	print("New emotionl state: " + str(emotional_state))
