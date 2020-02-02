extends KinematicBody2D
onready var anim=get_node("AnimationPlayer")
onready var my_sprite=get_node("AnimatedSprite")

export (int,0,100,10)var dano=50
var vec_dir=Vector2()
var targuet_pos=Vector2()
var speed=250
var movement=Vector2()
var enemy_body=null
var enemy_pos=null
var gravity=98.0
var state=0
var enemy_dist=null
var mirando=false

func _physics_process(delta):
	
	var my_pos=get_global_position()
	if enemy_body!=null:
		enemy_pos=enemy_body.get_global_position()
		
		enemy_dist=enemy_pos.distance_to(my_pos)
		if enemy_dist>=150 and not(mirando):
			targuet_pos=(enemy_pos-my_pos).normalized()
			state=1
		elif enemy_dist>=800:
			targuet_pos=Vector2()
			enemy_body=null
		elif enemy_dist<150 and not(mirando):
			targuet_pos=Vector2()
			state=2
			mirando=true
			atk()
			get_node("Timer").start()
	vec_dir.y+=gravity*delta
	vec_dir.x=targuet_pos.x
	movement.x=vec_dir.x*speed
	movement.y=vec_dir.y
	movement=move_and_slide(movement,Vector2.UP)
	
	if movement.x>0:
		my_sprite.flip_h=true
	elif movement.x<0:
		my_sprite.flip_h=false
#=========animation================
	match state:
		0:
			anim.play("Idle")
		1:
			anim.play("Walk")
		2:
			anim.play("Atack")


	
func _on_Area2D_body_entered(body):
	enemy_body=body


func _on_Timer_timeout():
	mirando=false

func atk():
	if vec_dir.x>0:
		get_node("Area2D2/Dir").disabled=false
	elif vec_dir.x<0:
		get_node("Area2D2/Esq").disabled=false


func _on_Area2D2_body_entered(body):
	if body.has_method("damage"):
		body.damage(dano)
	get_node("Area2D2/Dir").disabled=true
	get_node("Area2D2/Esq").disabled=true
