extends Node2D

var score_ia: int = 0
var score_player: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var full_length = get_viewport_rect().size.x
	var full_height = get_viewport_rect().size.y
	
	var x_player_score = full_length / 4
	var x_ia_score = full_length / 2 + x_player_score
	
	$ScorePlayer.position = Vector2(x_player_score, full_height / 4)
	$ScoreIA.position = Vector2(x_ia_score, full_height / 4)
	
	update_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func mark_point_for_ia():
	score_ia += 1
	update_score()
	
func mark_point_for_player():
	score_player += 1
	update_score()

func update_score():
	$ScorePlayer.text = str(score_player)
	$ScoreIA.text = str(score_ia)

func show_score():
	visible = true
	
func hide_score():
	visible = false
