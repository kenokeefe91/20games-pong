extends Node2D

@export var ball: Node2D

var tracking_speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lerp_ia(delta)
	
func tolerance_tracking(delta):
	var offset = 2
	if abs(ball.position.y - position.y) > offset:
		if ball.position.y > position.y:
			position.y += tracking_speed * delta
		
		if ball.position.y < position.y:
			position.y -= tracking_speed * delta

	position.y = clamp(
		position.y, 
		0 + $PaddleSprite.texture.get_size().y / 2, 
		get_viewport_rect().size.y - $PaddleSprite.texture.get_size().y / 2
	)
	
func lerp_ia(delta):
	var target_y = lerp(position.y, ball.position.y, 0.1)
	var distance = target_y - position.y
	position.y += clamp(distance, -tracking_speed * delta, tracking_speed * delta)