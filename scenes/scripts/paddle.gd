extends Node2D

var speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_y = get_viewport().get_mouse_position().y
	
	position.y = mouse_y
	
	if Input.is_action_pressed("ui_up"):
		position.y -= speed * delta
	
	if Input.is_action_pressed("ui_down"):
		position.y += speed * delta
		

	position.y = clamp(
		position.y, 
		0 + $PaddleSprite.texture.get_size().y / 2, 
		get_viewport_rect().size.y - $PaddleSprite.texture.get_size().y / 2
	)
