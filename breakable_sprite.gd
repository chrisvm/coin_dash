extends Node

@export var texture: Texture2D

var divisions = []
var div_size = floor(texture.get_size().x / 2)

func _ready() -> void:
	# create subdivisions
	divisions.append(Rect2i(0, 0, div_size, div_size))
	divisions.append(Rect2i(div_size, 0, div_size, div_size))
	divisions.append(Rect2i(0, div_size, div_size, div_size))
	divisions.append(Rect2i(div_size, div_size, div_size, div_size))
	
func reset():
	# if any texture are already created, delete them
	for node2d in find_children("*", "Node2D"):
		node2d.queue_free()
		
func explode():
	for rect in divisions:
		var sprite_section = Sprite2D.new()
		sprite_section.texture = self.texture
		sprite_section.region_enabled = true
		sprite_section.region_rect = rect
		add_child(sprite_section)
		
