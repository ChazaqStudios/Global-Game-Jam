tool
extends ViewportContainer

export (float,1.0,20.0,0.1)var escala_de_cinza=3.0

func _process(delta):
	material.set_shader_param("grayscale_scale",escala_de_cinza)
