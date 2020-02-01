extends CanvasLayer

onready var caracter_name=get_node("Panel/Caracter name")
onready var caracter_text=get_node("Panel/Caracter text")
onready var caracter_image=get_node("Sprite")

export (String, FILE, "*json") var dialog_path
var caracter
var dialog
var image
var dialog_to_use
var dialog_number=00
var stage


func load_dialog(data):
	var fille=File.new()
	assert fille.file_exists(data)
	
	fille.open(data,fille.READ)
	var dialogs= parse_json(fille.get_as_text())
	assert dialogs.size()>0
	return dialogs
	
func set_dialog():

	var dialog_dictionary
	
	stage=Globalscript.current_stage
	dialog_dictionary=load_dialog(dialog_path)
	dialog_to_use=dialog_dictionary[stage].values()
	
	caracter=dialog_to_use[dialog_number].caracter
	image=dialog_to_use[dialog_number].photo
	dialog=dialog_to_use[dialog_number].text
	
	caracter_name.set_text(caracter)
	caracter_text.set_text(dialog)
	
func next_dialog():
	if dialog_number+1==dialog_to_use.size():
		print("ok")
	else:
		dialog_number+=1
		set_dialog()
		print(dialog_number)
		print(dialog_to_use.size() )
	