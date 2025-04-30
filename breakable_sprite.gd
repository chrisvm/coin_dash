extends Node2D

var child_sprites: Array[RigidBody2D] = []

@export var centered: bool
@export var impulse_force: int
@export var texture: Texture2D
@export var breakage_scene: PackedScene
@export var lifetime: float
@export var trans_color: Color

func _ready() -> void:
	# create subdivisions
	var div_size = floor(texture.get_size().x / 2)
	var divisions = []
	divisions.append([
		Rect2i(0, 0, div_size, div_size), 
		Vector2i(-div_size/2, -div_size/2)
	])
	divisions.append([
		Rect2i(div_size, 0, div_size, div_size),
		Vector2i(div_size/2, -div_size/2)
	])
	divisions.append([
		Rect2i(div_size, div_size, div_size, div_size), 
		Vector2i(div_size/2, div_size/2)
	])
	divisions.append([
		Rect2i(0, div_size, div_size, div_size),
		Vector2i(-div_size/2, div_size/2)
	])
	
	# precreate the hidden sprites
	for rect in divisions:
		var breakage = breakage_scene.instantiate()
		breakage.hide()
		breakage.position = rect[1]
		
		var sprite_section = breakage.get_node("Sprite2D")
		sprite_section.texture = texture
		sprite_section.scale = scale
		sprite_section.region_enabled = true
		sprite_section.region_rect = rect[0]
		
		var body = breakage.get_node("CollisionShape2D")
		
		add_child(breakage)
		child_sprites.append(breakage)
		
func reset():
	# if any texture are already created, delete them
	for node2d in child_sprites:
		node2d.hide()
		
func explode():
	var waiters = []
	
	for child in child_sprites:
		child.show()
		
		# create impulse at position
		# since we already know the affected rigid bodies, we just need to
		var impulse_dir = child.position.normalized() * impulse_force
		child.apply_impulse(impulse_dir, child.position)
		child.apply_torque_impulse(randf_range(100.0, 1200.0))
		
		var tw = create_tween()
		tw.tween_property(child, "modulate", trans_color, lifetime / 2)
		waiters.append(tw.finished)
	
	for awaitable in waiters:
		await awaitable
