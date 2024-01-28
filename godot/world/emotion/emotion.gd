@tool
class_name Emotion extends CharacterBody2D


const COLOR_HAPPINESS = Color("ffe5c1")
const COLOR_SADNESS = Color("b6f7fc")

enum EmotionType {
	HAPPINESS = 1,
	SADNESS = -2
}

@export var movement_speed := 750.0
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
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var navigation_update_timer: Timer = $NavigationUpdateTimer



var player:Node2D

func _ready() -> void:
	
	player = get_tree().get_first_node_in_group("Player") as Node2D
	
	navigation_update_timer.timeout.connect(_update_navigation)
	
	# enforce setget
	self.emotion_type = emotion_type
	navigation_agent_2d.path_desired_distance = 8.0
	navigation_agent_2d.target_desired_distance = 8.0
	navigation_agent_2d.debug_enabled = false
	
	
func _update_navigation() -> void:
	if emotion_type == EmotionType.SADNESS:
		set_target_position(player.global_position)
	if emotion_type == EmotionType.HAPPINESS:
		# TODO: avoid player?
		pass


func set_target_position(target_position:Vector2) -> void:
	navigation_agent_2d.target_position = target_position


func _physics_process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
