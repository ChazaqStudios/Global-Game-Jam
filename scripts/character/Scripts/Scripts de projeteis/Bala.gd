extends Area2D
const SPEED = 200

func _ready():
	set_process(true)
	
func _process(delta):
	var speed_x=-2.4
	var speed_y=0
	var motion= Vector2(speed_x, speed_y) * SPEED
	set_position(get_position()+ motion *delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Tiro_inimigoE_body_entered(body):
	if body.has_method("dano"):
		body.dano(25)

	queue_free()


