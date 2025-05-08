extends Node

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var obstacle_scene: PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screensize = DisplayServer.window_get_size()
	$Player.screensize = screensize
	$Player.hide()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	
	$Player.start()
	$Player.show()
	
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
	$GameTimer.start()
	spawn_obstacles()
	spawn_coins()
	
	$LevelSound.play()

func spawn_obstacles():
	var o = obstacle_scene.instantiate()
	add_child(o)
	o.position = Vector2(
		randi_range(0, screensize.x),
		randi_range(0, screensize.y)
	)

func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.position = Vector2(
			randi_range(0, screensize.x),
			randi_range(0, screensize.y)
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var coins = get_tree().get_nodes_in_group("coins")
	if playing and coins.size() == 0:
		level += 1
		time_left += 5
		
		spawn_obstacles()
		spawn_coins()
		
		# set the spawn of the powerup on a timer
		$PowerupTimer.wait_time = randf_range(1, 3)
		$PowerupTimer.start()
		
		
func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$HUD.show_game_over()
	$Player.die()


func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left < 0:
		game_over()

func _on_player_hurt() -> void:
	game_over()

func _on_player_pickup(type) -> void:
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)

func _on_hud_start_game() -> void:
	new_game()

func _on_powerup_timer_timeout() -> void:
	var powerup = powerup_scene.instantiate()
	add_child(powerup)
	powerup.position = Vector2(
		randi_range(0, screensize.x),
		randi_range(0, screensize.y)
	)
