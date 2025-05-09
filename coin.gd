extends Area2D

@export var lifetime_after_pickup: float

var screensize: Vector2

func _ready() -> void:
	$BreakableSprite.reset()
	$BreakableSprite.scale = $AnimatedSprite2D.scale
	$BreakableSprite.lifetime = lifetime_after_pickup
	
	# randomize the coin animation
	$Timer.start(randf_range(0, 8))
	
	# get screensize
	screensize = DisplayServer.window_get_size()

func pickup():
	remove_from_group("coins")
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	# hide to replace with exploded sprite
	$AnimatedSprite2D.hide()
		
	# first explode the coin sprite
	await $BreakableSprite.explode()
	
	queue_free()

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacle"):
		position = Vector2(
			randi_range(0, screensize.x),
			randi_range(0, screensize.y)
		)
