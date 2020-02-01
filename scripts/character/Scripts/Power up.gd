extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(int,"","arma1", "arma2","arma3")var balas=1
export(int,"","Medikit","Weapon")var poweruptipe=2
func _ready():
	if poweruptipe==1:
		get_node("HP").show()
	elif poweruptipe==2:
		match balas:
			1:get_node("Metralhadora").show()
			2:get_node("Sniper").show()
			3:get_node("Shotgun").show()



func _on_Power_up_body_shape_entered(body_id, body, body_shape, area_shape):
	match poweruptipe:
		1:
			if body.has_method("UP_HP"):
				body.UP_HP(20)
		2:
			if body.has_method("pegarma"):
				body.pegarma(balas)
		
	queue_free()