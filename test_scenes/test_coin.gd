extends Node

@export var coin_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Coin.position = $CoinSpawnpoint.position

func _on_explode_button_pressed() -> void:
	$Coin.pickup()

func _on_reset_button_pressed() -> void:
	var existing_coin = find_child("Coin")
	if not existing_coin:
		var new_coin = coin_scene.instantiate()
		new_coin.position = $CoinSpawnpoint.position
		add_child(new_coin)
	
