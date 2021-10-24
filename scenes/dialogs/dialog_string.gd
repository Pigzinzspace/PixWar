extends TextureRect
var dialogs_key = -1
var dialog_text = ""
signal i_was_chosen(dialogs_key)




func _ready():
	$Label.text = dialog_text


func _on_TextureRect_gui_input(event):
	emit_signal("i_was_chosen",dialogs_key)
