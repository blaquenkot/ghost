extends Node2D

const Utils = preload("utils.gd")

var padding = Vector2(64,64)
var DualShot = preload("res://shot/DualShot.tscn")
var Sparks = preload("res://shot/Sparks.tscn")
var EndScreen = preload("res://screens/EndScreen.tscn")
var WinScreen = preload("res://screens/WinScreen.tscn")
var current_shot

var potion_position = 6800
var potion_appeared = false

var boss_position = 8100
var boss_appeared = false

var max_lifes = 6
var lifes

var can_shoot = true

func _ready():
	set_full_lifes()

func _process(delta):
	if $Player1 && $Player2:
		if !boss_appeared:
			$Camera2D.position.x = abs($Player1.position.x - $Player2.position.x) * 0.5 + min($Player1.position.x, $Player2.position.x)
			$Camera2D.position.y = abs($Player1.position.y - $Player2.position.y) * 0.5 + min($Player1.position.y, $Player2.position.y)

			var limits = get_limits()
	
			$Player1.min_pos = limits["min"]
			$Player1.max_pos = limits["max"]
			$Player2.min_pos = limits["min"]
			$Player2.max_pos = limits["max"]
	
		if !potion_appeared && $Camera2D.position.x >= potion_position: #lol
			potion_appeared()
	
		if !boss_appeared && $Camera2D.position.x >= boss_position: #lol
			boss_appeared()
			
		if Input.is_action_just_pressed("cheat"): #cheat
			set_full_lifes()
	
		if can_shoot && !current_shot && Input.is_action_just_pressed("dual_action"):
			can_shoot = false
			$ShotCoolDownTimer.start()
			current_shot = dual_shot()

func dual_shot():
	var shot = DualShot.instance()
	add_child(shot)
	$ShotTimer.start()
	shot.summon_between($Player1, $Player2)

	create_sparks_for($Player1)
	create_sparks_for($Player2)
	
	return shot

func create_sparks_for(entity):
	if Utils.can_run_particles():
		var particles = Sparks.instance()
		entity.add_child(particles)
		particles.emitting = true

func get_limits():
	var ctrans = get_canvas_transform()
	var min_pos = -ctrans.get_origin() / ctrans.get_scale()
	var view_size = get_viewport_rect().size / ctrans.get_scale()
	var max_pos = min_pos + view_size
	
	return {"min": min_pos + padding, "max": max_pos - padding}

func _on_ShotTimer_timeout():
	if current_shot:
		current_shot.queue_free()
		current_shot = null
		
	$ShotTimer.stop()
	
func _on_player_took_damage():
	lifes -= 1
	
	if lifes >= 0:
		$CanvasLayer/MarginContainer/VBoxContainer/TextureRect.texture = load("res://assets/health/health%s.png" % lifes)
		
	if lifes <= 0:
		the_end()
	
func _on_boss_took_damage(new_health):
	if new_health >= 0:
		$CanvasLayer/MarginContainer/VBoxContainer/TextureRect2.texture = load("res://assets/health/bosshealth%s.png" % new_health)
		
	if new_health <= 0:
		win_game()
		
func potion_appeared():
	potion_appeared = true
	
	play_calm_music()
		
func boss_appeared():
	boss_appeared = true
	
	play_boss_music()

	var view_size = get_viewport_rect().size / get_canvas_transform().get_scale()
	var min_pos = boss_position - view_size.x * 0.25
	var max_pos = boss_position + view_size.x
	
	$Camera2D.position.x = boss_position + view_size.x*0.3
	$Camera2D.position.y *= 0.7
	
	$Player1.min_pos.x = min_pos
	$Player1.max_pos.x = max_pos
	$Player2.min_pos.x = min_pos
	$Player2.max_pos.x = max_pos
	$CanvasLayer/MarginContainer/VBoxContainer/TextureRect2.visible = true
	$Path2D/PathFollow2D/Enemy14.visible = true

func play_calm_music():
	$MusicPlayer.stop()
	$BossMusicPlayer.stop()
	$CalmMusicPlayer.play()
	
func play_boss_music():
	$MusicPlayer.stop()
	$CalmMusicPlayer.stop()
	$BossMusicPlayer.play()

func set_full_lifes():
	lifes = max_lifes
	$CanvasLayer/MarginContainer/VBoxContainer/TextureRect.texture = load("res://assets/health/health%s.png" % lifes)

func win_game():
	global.winSFXPlayer.play()
	$Player1.can_be_controlled = false
	$Player2.can_be_controlled = false
	$WinGameTimer.start()

func clean():
	if current_shot:
		current_shot.queue_free()
		current_shot = null
		
	$Player1.queue_free()
	$Player2.queue_free()

func the_end():
	global.gameOverSFXPlayer.play()
	
	var end_screen = EndScreen.instance()
	
	clean()
	
	add_child(end_screen)

func _on_Potion_player_took_potion():
	set_full_lifes()

func _on_WinGameTimer_timeout():
	var win_screen = WinScreen.instance()
	
	clean()
		
	add_child(win_screen)

func _on_ShotCoolDownTimer_timeout():
	can_shoot = true
