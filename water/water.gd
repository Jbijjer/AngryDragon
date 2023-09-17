extends Area2D

@onready var splash = $Splash


func _on_body_entered(body):
	if body.is_in_group(GameManager.GROUP_ANIMAL):
		splash.play()
