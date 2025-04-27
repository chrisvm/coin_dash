extends Node2D

var child_sprites = []

func _ready() -> void:
	# create subdivisions
	var texture = preload("res://assets/coin-frame-1.png")
	
	var div_size = floor(texture.get_size().x / 2)
	var divisions = []
	divisions.append(Rect2i(0, 0, div_size, div_size))
	divisions.append(Rect2i(div_size, 0, div_size, div_size))
	divisions.append(Rect2i(0, div_size, div_size, div_size))
	divisions.append(Rect2i(div_size, div_size, div_size, div_size))
	
	# precreate the hidden sprites
	for rect in divisions:
		var sprite_section = Sprite2D.new()
		sprite_section.hide()
		sprite_section.texture = texture
		sprite_section.position = rect.position
		sprite_section.region_enabled = true
		sprite_section.region_rect = rect

		add_child(sprite_section)
		child_sprites.append(sprite_section)
		
func reset():
	# if any texture are already created, delete them
	for node2d in child_sprites:
		node2d.position = Vector2.ZERO
		node2d.hide()
		
func explode():
	for node2d in child_sprites:
		node2d.show()
	
