extends Area2D

@export var lifetime_after_pickup: float

func _ready() -> void:
	$BreakableSprite.reset()
	$BreakableSprite.scale = $AnimatedSprite2D.scale
	$LifetimeTimer.wait_time = lifetime_after_pickup	

func pickup():
	remove_from_group("coins")
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	# hide to replace with exploded sprite
	$AnimatedSprite2D.hide()
		
	# first explode the coin sprite
	$BreakableSprite.explode()
	
	$LifetimeTimer.start()
	await $LifetimeTimer.timeout
	
	queue_free()
