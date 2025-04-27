extends Area2D

var screensize = Vector2.ZERO

func _ready() -> void:
	$BreakableSprite.reset()
	$BreakableSprite.scale = $AnimatedSprite2D.scale
	

func pickup():
	$CollisionShape2D.set_deferred("disabled", true)
	
	# first explode the coin sprite
	$BreakableSprite.explode()
	
	# play tweened scaling anim
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	tw.tween_property($AnimatedSprite2D, "scale", scale * 1.5, 0.2)
	tw.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.2)
	await tw.finished
	
	queue_free()
