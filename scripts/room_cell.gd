extends Node2D
var cell_type  
var cell_sub_type
var cell_tile_id = 0
var cell_name
var tween

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.texture = MyGlobal.load_tile_by_index(cell_tile_id)
	tween = $Tween
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureRect_gui_input(event):
	if event.is_action_released("ui_accept"):
		get_parent().get_parent().cell_pressed(self)
		pass # Replace with function body.

func select():
	tween.stop_all()
	$TextureRect.material.set_shader_param("flash_modifier",0.5)
	$TextureRect.material.set_shader_param("flash_color",Color8(74,225,9,255))
	
	pass

func unselect():
	$TextureRect.material.set_shader_param("flash_modifier",0.0)
	$TextureRect.material.set_shader_param("flash_color",Color8(253,31,244,255))
	pass



func _on_TextureRect_mouse_entered():
	if $TextureRect.material.get_shader_param("flash_color") == Color8(74,225,9,255) :
		return
	tween.remove_all()	
	tween.repeat = true
	tween.interpolate_property($TextureRect.material,"shader_param/flash_modifier",
	0.0,1.0, 0.5, tween.TRANS_LINEAR, tween.EASE_IN)
	tween.interpolate_property($TextureRect.material,"shader_param/flash_modifier",
	1.0,0.0, 0.5, tween.TRANS_LINEAR, tween.EASE_IN,0.5)
	tween.start()
#	pass # Replace with function body.


func _on_TextureRect_mouse_exited():
	if $TextureRect.material.get_shader_param("flash_color") == Color8(74,225,9,255) :
		return
	tween.stop_all()
	tween.repeat = false
	tween.resume_all()
	pass # Replace with function body.
