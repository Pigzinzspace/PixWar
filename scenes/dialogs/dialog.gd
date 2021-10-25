extends TextureRect
var dialogs = {
	"where_am_i":{"dialog":"Wat is the place here?","NPC_dialog":"here is the main HUB, the source of everything","call":"","close":[],"show":[]},
	"who_am_i":{"dialog":"Who am i?","NPC_dialog":"You're Printed out of nowhere.","call":"","close":["who_am_i"],"show":["hello"]},
	"hello":{"dialog":"Hello, i am Printed","NPC_dialog":"Hi, i see who you are. Do you want a job?","call":"","close":["hello"],"show":["bye","what_the_job"]},
	"bye":{"dialog":"Bye, i'm moving on","NPC_dialog":"Goodbye, keep your colors!","call":"end_dialog","close":[],"show":[]},
	"who_are_you":{"dialog":"Who are you?","NPC_dialog":"I am Vasya, the Test NPC!","call":"","close":[],"show":[]},
	"what_the_job":{"dialog":"What is this job?","NPC_dialog":"Two guys are here nearby, a lot of good, they stole it, let's go, you will scare them and i will support you!","call":"","close":["what_the_job"],"show":['want_rob_guys']},
	"want_rob_guys":{"dialog":"I don't want to rob 2 guys. I played Gothic 1.","NPC_dialog":"As you wish bro!","call":"","close":["want_rob_guys"],"show":[]}
}
var dialog_progress = {
	"test_NPC":["who_am_i","where_am_i","who_are_you"]
}
var npc_key = "test_NPC"
var npc_name = MyGlobal.NPCs[npc_key]
var dialog_options = []
#это может понадобиться но пока это не нужно 
func open_dialog_menu():
	dialog_options = dialog_progress[npc_key]
#	var my_dialog_string = load("res://scenes/dialogs/dialog_string.tscn")
	$ItemList.clear()
	for i in dialog_options.size():
		$ItemList.add_item(dialogs[dialog_options[i]].dialog)
#		add_my_dialog_string(dialog_options[i],my_dialog_string)
	
#func add_my_dialog_string(dialogs_key,my_dialog_string) :
	
#	var my_dialog_string_instance = my_dialog_string.instance()
#	my_dialog_string_instance.rect_position = Vector2(0,dialog_strings.size()*32)
#	my_dialog_string_instance.dialog_text = dialogs[dialogs_key].dialog 
#	my_dialog_string_instance.dialogs_key = dialogs_key
#	my_dialog_string_instance.connect("i_was_chosen",self,"on_dialog_string_was_chosen")
#	add_child(my_dialog_string_instance)
#	dialog_strings.append(my_dialog_string_instance)
#
	
#func on_dialog_string_was_chosen(dialogs_key):
## dialogs_id - строка выбранного диалога в списке всех диалогов
## dialog_options - текущие ключи строк диалога для НПС с ключом d_ID
## dialog_progress - масив GUI сцен, сгенерированых по ключам  dialog_options для НПС с ключем d_ID
#	var dialogs_value =dialogs[dialogs_key]
#	show_the_answer(dialogs_value.NPC_dialog)
#	var dialog_options = dialog_progress[NPC]
#	for i in dialogs_value.show.size():
#		if !(dialogs_value.show[i] in dialog_options) :
#			dialog_options.append(dialogs_value.show[i])
#	var j = 0 
#	while j <  dialog_options.size() :
#		if dialog_options[j] in dialogs_value.close:
#			dialog_options.remove(j)
#		else: j+=1
#	dialog_progress[NPC] = dialog_options
#	if dialogs_value.call != "":
#		call(dialogs_value.call)
#	open_dialog_menu()


func show_the_answer(question,answer):
	$RichTextLabel.append_bbcode("[color=aqua]You:[/color]\n\r")
	$RichTextLabel.append_bbcode(question)
	$RichTextLabel.append_bbcode("[right][color=yellow]"+npc_name+":[/color][/right]")
	$RichTextLabel.append_bbcode("[right]"+answer+"[/right]\n\r")
	
	pass


func end_dialog():
	queue_free()
	pass


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$RichTextLabel2.append_bbcode("Dialogue [color=aqua]You[/color] and "+"[color=yellow]"+npc_name+"[/color] !")
	open_dialog_menu()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ItemList_item_selected(dialogs_key):
	var dialogs_value = dialogs[dialog_options[dialogs_key]]
	show_the_answer(dialogs_value.dialog, dialogs_value.NPC_dialog)
	
	for i in dialogs_value.show.size():
		if !(dialogs_value.show[i] in dialog_options) :
			dialog_options.append(dialogs_value.show[i])
	var j = 0 
	while j <  dialog_options.size() :
		if dialog_options[j] in dialogs_value.close:
			dialog_options.remove(j)
		else: j+=1
	dialog_progress[npc_key] = dialog_options
	if dialogs_value.call != "":
		call(dialogs_value.call)
	open_dialog_menu()
	
