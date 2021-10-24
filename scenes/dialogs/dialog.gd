extends TextureRect
var interlocutor = {"test_NPC": "Vasya"}
var dialogs = {
	"where_am_i":{"dialog":"Wat is the place here?","NPC_dialog":"here is the main HUB, the source of everything","call":"","close":[],"show":[]},
	"who_am_i":{"dialog":"Who am i?","NPC_dialog":"You're Printed out of nowhere","call":"","close":["who_am_i"],"show":["Hello"]},
	"hello":{"dialog":"Hello, i am Printed","NPC_dialog":"hi i see who you are","call":"","close":["hello"],"show":["bye"]},
	"bye":{"dialog":"bye, i'm moving on","NPC_dialog":"Goodbye, keep your colors!","call":"end_dialog","close":[],"show":[]}
}
var dialog_strings = []
var dialog_progress = {
	interlocutor.test_NPC:[dialogs.who_am_i,dialogs.where_am_i]
}
var NPC = interlocutor.test_NPC
#это может понадобиться но пока это не нужно 
var NPC_instance = null 

func open_dialog_menu():
	var dialog_options = dialog_progress[NPC]
	var my_dialog_string = load("res://scenes/dialogs/dialog_string.tscn")
	for i in dialog_options.size():
		add_my_dialog_string(dialog_options[i],my_dialog_string)
	
func add_my_dialog_string(dialogs_key,my_dialog_string) :
	var my_dialog_string_instance = my_dialog_string.instance()
	my_dialog_string_instance.rect_position = Vector2(0,dialog_strings.size()*32)
	my_dialog_string_instance.dialog_text = dialogs[dialogs_key].dialog 
	my_dialog_string_instance.dialogs_key = dialogs_key
	my_dialog_string_instance.connect("i_was_chosen",self,"on_dialog_string_was_chosen")
	add_child(my_dialog_string_instance)
	dialog_strings.append(my_dialog_string_instance)
	
	
func on_dialog_string_was_chosen(dialogs_key):
# dialogs_id - строка выбранного диалога в списке всех диалогов
# dialog_options - текущие ключи строк диалога для НПС с ключом d_ID
# dialog_progress - масив GUI сцен, сгенерированых по ключам  dialog_options для НПС с ключем d_ID
	var dialogs_value =dialogs[dialogs_key]
	show_the_answer(dialogs_value.NPC_dialog)
	var dialog_options = dialog_progress[NPC]
	for i in dialogs_value.show.size():
		if !(dialogs_value.show[i] in dialog_options) :
			dialog_options.append(dialogs_value.show[i])
	var j = 0 
	while j <  dialog_options.size() :
		if dialog_options[j] in dialogs_value.close:
			dialog_options.remove(j)
		else: j+=1
	dialog_progress[NPC] = dialog_options
	for i in dialog_strings.size():
		dialog_strings[i].queue_free()
	dialog_strings = []
	if dialogs_value.call != "":
		call(dialogs_value.call)
	open_dialog_menu()


func show_the_answer(answer):
	pass


func end_dialog():
	queue_free()
	pass


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
