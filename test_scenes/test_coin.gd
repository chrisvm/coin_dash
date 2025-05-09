extends Node

@export var coin_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Coin.position = $CoinSpawnpoint.position

func _on_explode_button_pressed() -> void:
	if has_node("Coin"):
		$Coin.pickup()

func _on_reset_button_pressed() -> void:
	var existing_coin = get_node("Coin")
	if not existing_coin:
		var new_coin = coin_scene.instantiate()
		new_coin.name = "Coin"
		new_coin.lifetime_after_pickup = 1.5
		new_coin.position = $CoinSpawnpoint.position
		add_child(new_coin)
	
