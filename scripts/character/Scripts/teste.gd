extends Area2D
const SPEED = 200

func _on_Area2D_body_entered(body):
	body.HP=body.HP-25
	queue_free() # replace with function body
#

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
