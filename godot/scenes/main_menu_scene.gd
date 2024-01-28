extends Node2D

var game_scene = "res://scenes/ingame_scene.tscn"
var settings_scene = "res://scenes/game_settings_scene.tscn"

@onready var overlay := %FadeOverlay
@onready var new_game_button := %NewGameButton
@onready var settings_button := %SettingsButton
@onready var exit_button := %ExitButton

var next_scene:String = game_scene

var initialized = false

func _ready() -> void:
	settings_button.disabled = settings_scene == null
	
	# connect signals
	new_game_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	overlay.on_complete_fade_out.connect(_on_fade_overlay_on_complete_fade_out)
	
	new_game_button.grab_focus()
	

func _process(delta: float) -> void:
	if not initialized:
		initialized = true
		

func _on_settings_button_pressed() -> void:
	next_scene = settings_scene
	overlay.fade_out()
	
func _on_play_button_pressed() -> void:
	next_scene = game_scene
	overlay.fade_out()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_fade_overlay_on_complete_fade_out() -> void:
	get_tree().change_scene_to_file(next_scene)
