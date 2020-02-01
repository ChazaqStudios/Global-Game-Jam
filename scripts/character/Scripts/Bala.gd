extends Area2D
const SPEED = 200
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)
	
func _process(delta):
	var speed_x=-2.4
	var speed_y=0
	var motion= Vector2(speed_x, speed_y) * SPEED
	set_position(get_position()+ motion *delta)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Tiro_inimigoE_body_entered(body):
	if body.tipo=="humano":
		body.dano(25)
	#body.HP=body.HP-35
	queue_free()


