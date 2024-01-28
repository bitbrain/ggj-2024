extends Node2D


const WIN_HAPPINESS = 5

const GameOverScene = preload("res://scenes/game_over_scene.tscn")
const MenuScene = preload("res://scenes/main_menu_scene.tscn")


@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay
@onready var receptors: Array[Node] = %Receptors.get_children()
@onready var spawner: PointSpawner = %Emotions
@onready var player: Player = $Entities/Player
@onready var win_light: PointLight2D = $WinLight
@onready var ambience: AudioStreamPlayer = $Ambience
@onready var win_sound: AudioStreamPlayer = $WinSound
@onready var laugh_quote: RichTextLabel = $UI/LaughQuote


var emotional_state := 0
var ready_to_restart := false


func _ready() -> void:
	fade_overlay.visible = true
	
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())
	
	pause_overlay.game_exited.connect(_save_game)
	
	for receptor:Receptor in receptors:
		receptor.emotions_received.connect(_on_emotions_received)
		
	player.dead.connect(_on_game_over)

func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true
	elif ready_to_restart:
		if event is InputEventMouseButton or event is InputEventKey or event is InputEventJoypadButton:
			get_tree().paused = false
			get_tree().change_scene_to_packed(MenuScene)
		
func _save_game() -> void:
	SaveGame.save_game(get_tree())
	
	
func _on_emotions_received() -> void:
	emotional_state += 1
	spawner.start_spawning()
	if emotional_state >= WIN_HAPPINESS:
		get_tree().paused = true
		var light_tween = create_tween()
		light_tween.tween_property(win_light, "energy", 16, 6.0)\
		.finished.connect(_on_win)
		var ambience_tween = create_tween()
		ambience_tween.tween_property(ambience, "volume_db", -99, 2.0)\
		.finished.connect(ambience.stop)
		win_sound.play()
		
		
func _on_win() -> void:
	var quote_animation = create_tween()
	quote_animation.tween_property(laugh_quote, "visible_ratio", 1, 6.0)\
	.finished.connect(_laugh_quote_shown)
	

func _laugh_quote_shown() -> void:
	ready_to_restart = true
	
	
func _on_game_over() -> void:
	get_tree().change_scene_to_packed(GameOverScene)
