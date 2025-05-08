extends Area2D

signal hurt
signal pickup

@export var speed = 350

var velocity = Vector2.ZERO
var screensize = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Input.get_vector("Left", "Right", "Up", "Down")
	position += velocity * speed * delta
	
	# clamp to screen
	position = position.clamp(Vector2(0, 0), screensize)
	
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0


func start():
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"


func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
		
	if area.is_in_group("powerup"):
		area.pickup()
		pickup.emit("powerup")
	
	if area.is_in_group("obstacle"):
		hurt.emit()
		die()
