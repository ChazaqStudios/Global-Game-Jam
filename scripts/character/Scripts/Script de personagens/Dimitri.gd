extends "res://Scripts/Script de personagens/personagens codigo padrão.gd"



onready var Dimitri_info = {
	"armas":{
	"weapon_slot":weapon_slot,
	0:preloadwepons[0],
	1:preloadwepons[1],
	2: preloadwepons[2],
	3: preloadwepons[3]
    		},
	"recuo":{
				0: .3,
				1:.15,
				2: .5,
				3: .5 #recuo é o tempo que uma arma vai levar para disparar, o primeiro valor é da metralhadora, o segundo da shotgun e o terceiro da sniper
			},
	"municao":{
		1:0,
		2:0,
		3:0
			},
	"HP":1,
	"Weapon_anim":null,
	"Max_HP":100,
	"Personagem_name":"default"
}
