extends TextureRect
var rh_pressed_ms_time = 0
var lh_pressed_ms_time = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(rect_position)
	pass


func _on_rh_TextureRect_gui_input(event):
	if event.is_action_released("ui_accept"):
		if rh_pressed_ms_time != 0 :
			pass
		
	
	
