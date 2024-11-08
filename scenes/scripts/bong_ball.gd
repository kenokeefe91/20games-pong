extends Node2D

const STATIONNARY_STATE : int = 0
const MOVING_STATE : int = 1
const PAUSE_STATE : int = 2

var current_state: int

var moving_vector: Vector2
var ball_speed = 700
var base_speed = 700

@export var player_paddle: Node2D
@export var ia_paddle: Node2D

signal point_for_player
signal point_for_ia

signal pause_game
signal stop_pause

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stationnary_state()
	pass # Replace with function body.

func set_stationnary_state():
	current_state = STATIONNARY_STATE
	
	var start_y = get_viewport_rect().size.y / 2
	var start_x = get_viewport_rect().size.x / 2
	
	position = Vector2(start_x, start_y)
	set_direction_vector()
	emit_signal("pause_game")
	var ball_speed = base_speed

func set_direction_vector():
	var start_x = randf_range(-1, 1)
	var start_y = randf_range(-0.05, 0.05)
	
	moving_vector = Vector2(start_x, start_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if current_state == STATIONNARY_STATE:
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("stop_pause")
			current_state = MOVING_STATE
			return

	if current_state == PAUSE_STATE:
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("stop_pause")
			current_state = MOVING_STATE
		return

	if current_state == MOVING_STATE:
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("pause_game")
			current_state = PAUSE_STATE
		apply_moving_vector(delta)

func apply_moving_vector(delta: float):
	position += moving_vector.normalized() * ball_speed * delta

func _on_area_2d_area_entered(area: Area2D):
	ball_speed += 5
	if area.name == "GameWall":
		moving_vector.y *= -1

	if area.name == "PaddleCollision":
		if moving_vector.x < 0:
			set_moving_vector_after_paddle_collision(player_paddle)
			return
		if moving_vector.x > 0:
			set_moving_vector_after_paddle_collision(ia_paddle)
			return 

	if area.name == "MarkingAreaPlayerOne":
		emit_signal("point_for_ia")
		set_stationnary_state()
		
	if area.name == "MarkingAreaIA":
		emit_signal("point_for_player")
		set_stationnary_state()
	

func set_moving_vector_after_paddle_collision(paddle_collision: Node2D):
	var offset = 0 

	var coeff = abs(paddle_collision.position.y - position.y)
	
	var y_max_offset = coeff / 50

	if paddle_collision.position.y - position.y > 0: # superior paddle
		offset = randf_range(-y_max_offset, 0)
		
	if paddle_collision.position.y - position.y < 0: # Inferior paddle
		offset = randf_range(0, y_max_offset)
	
	moving_vector = Vector2(-moving_vector.x, moving_vector.y + offset)
