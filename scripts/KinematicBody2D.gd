extends KinematicBody2D

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel
const FLOOR_ANGLE_TOLERANCE = 40
const JUMP_MAX_AIRBORNE_TIME = 0.2

export (float,0,1000,0.2)var gravity=500.0
export (int,0,700,10)var walk_speed=600
export (int,0,10000,10)var jump_speed_normal=100
export (int,0,10000,10)var jump_speed_totem=200
export (int,0,1000,10)var speed_max_normal=200
export (int,0,1000,10)var speed_max_totem=300
export (int,0,1000,10)var speed_min=10
export (int,0,1000,10)var hp_max
export (int,0,10000,10) var stop_force = 1300
export (float,0,3,0.1)var cool_down_padrao=0.1
export (Array) var totens = [false,false,false,false,false,false]

onready var jag_sprite=get_node("Sprite")
onready var animation=get_node("AnimationPlayer")
onready var totens_node=get_node("CanvasLayer/totens")
onready var passos=get_node("Passos")
onready var hp_bar=get_node("CanvasLayer/TextureProgress")
onready var tw=get_node("Tween")

var move_vec=Vector2()
var dir_vec=Vector2()
var live=true
var hp
var snap=Vector2(0,32)
var init_grav=gravity
var speed_max
var jump_speed=300
var jumping = false
var on_floor=true
var prev_jump_pressed = false

var velocity = Vector2()
var on_air_time = 100
var cool_down=0.2
var can_slide=false
var on_wall_jump=false
func _ready():
	hp=hp_max
	hp_bar.set_value(hp)
	
	actualise_totens()


func _physics_process(delta):
	# Create forces
	snap=Vector2(0,32)
	var force = Vector2(0, gravity)

	var walk_left = Input.is_action_pressed("left")
	var walk_right = Input.is_action_pressed("right")
	var jump = Input.is_action_pressed("cross")
	var jump2 = Input.is_action_just_pressed("cross")
	var run= Input.is_action_pressed("square")
	var atack= Input.is_action_pressed("triangle")
#----------------movement-----------------------------------------------------
	if run and (totens[0]==true):
		speed_max=speed_max_totem
	else:
		speed_max=speed_max_normal

	if totens[0]==true:
		jump_speed=jump_speed_totem
	else:
		jump=jump_speed_normal

	var stop = true

	if not(on_wall_jump):
		if walk_left:
			if velocity.x <= speed_min and velocity.x > -speed_max:
	
				force.x -= walk_speed
				stop = false
				jag_sprite.flip_h=true
		elif walk_right:
			if velocity.x >= -speed_min and velocity.x < speed_max:
				force.x += walk_speed
				stop = false
				jag_sprite.flip_h=false
#	if not(on_wall_jump):
#		if walk_left:
#			force.x=-walk_speed
#			jag_sprite.flip_h=true
#		elif walk_right:
#			force.x=+walk_speed
#			jag_sprite.flip_h=false
#		else:
#			velocity.x=0
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)

		vlen -= stop_force * delta
		if vlen < 0:
			vlen = 0

		velocity.x = vlen * vsign
	


	if is_on_wall() and not is_on_floor() and can_slide and (totens[2]==true):
		
		force.y=force.y/0.1
		velocity.y=0
		animation.play("wall_idle")
		snap=Vector2()
		jumping=false
		
		if jump2 or on_wall_jump:
			animation.play("wall_jump")
			velocity.y-=jump_speed*1.3
			if walk_left:
				jag_sprite.flip_h=false
				velocity.x+= walk_speed
			elif walk_right:
				jag_sprite.flip_h=true
				velocity.x-=walk_speed
			on_wall_jump=true
			get_node("Timer2").start()
	if is_on_floor():
		on_air_time = 0
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if jump:
		print(on_air_time<JUMP_MAX_AIRBORNE_TIME, not(prev_jump_pressed),not jumping)
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		snap=Vector2()
		velocity.y = -jump_speed
		jumping = true
		can_slide=false
		get_node("Timer").start()
	on_air_time += delta
	prev_jump_pressed = jump

	velocity += force * delta

	velocity = move_and_slide_with_snap(velocity, snap,Vector2(0, -1),true,40)
#-------------------animation----------------------------------------------------------
	if (velocity.x<0.2 and velocity.x>-0.2) and velocity.y==0 :
		animation.play("Idle")
	elif (velocity.x>0.2 or velocity.x<-0.2) and velocity.y==0:
		animation.play("Run")
		if is_on_floor():
			if not(passos.is_playing() ):
				passos.play()
	elif velocity.y!=0 and not (is_on_floor() or is_on_wall() and not(on_wall_jump)) :
		if animation.get_current_animation()!="Jump":
			animation.play("Jump")


#---------------------atack and interactions----------------------------------------------

	if cool_down>0:
		cool_down-=delta

	if atack:
		if cool_down<=0:
			cool_down=cool_down_padrao

func actualise_totens():
	var children=totens_node.get_children()
	for x in rand_range(0, children.size()-1):
		if totens[x]==true:
			children[x].visible=true
	

func new_totem(index):
	totens[index]=true
	print(index)
	actualise_totens()



func _on_Timer_timeout():
	can_slide=true


func _on_Timer2_timeout():
	on_wall_jump=false



func damage(dano):
	hp-=dano
	if hp<0:
		hp=0
	update_hp()
	
func update_hp():
	#hp_bar.set_value(hp)
	tw.interpolate_property(hp_bar,"value",hp_bar.get_value(),hp,0.5,Tween.TRANS_LINEAR,Tween.EASE_IN,0)
	tw.start()

