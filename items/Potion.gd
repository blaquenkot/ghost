extends Sprite

signal player_took_potion

func _on_FlashTimer_timeout():
	if modulate == Color(1,1,1,1):
		modulate = Color(10,10,10,1)
	else: 
		modulate = Color(1,1,1,1)

func _on_Area2D_body_entered(body):
	if 'Player' in body.name:
		emit_signal('player_took_potion')
		global.potionSFXPlayer.play()
		$FlashTimer.stop()
		queue_free()