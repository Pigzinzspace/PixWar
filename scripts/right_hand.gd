extends Control
var rh_pressed_ms_time = 0
var rh_pressed_ms_start = 0
var old_position = Vector2(242,-15)
var stage setget stage_set 
var tween 
signal opponent_hited(damage)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func stage_set(value):
	if value == 0:
		$rh_TextureRect.material.set_shader_param("outline_width",0.2)
	else:
		$rh_TextureRect.material.set_shader_param("outline_width",0.0)
	stage = value

# Called when the node enters the scene tree for the first time.
func _ready():
	
	tween = $"../Tween2"

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		var mouse_xy = get_local_mouse_position()
		if stage == 1:
			rh_move()
		elif mouse_xy.x>=0 and mouse_xy.x<= rect_size.x and mouse_xy.y>=0 and mouse_xy.y<= rect_size.y:
			rh_move()	
	elif Input.is_action_just_released("ui_accept"):
		if stage == 1:
			rh_move()
			
func rh_move():
	if stage != 0:
		rh_pressed_ms_time = OS.get_ticks_msec() - rh_pressed_ms_start
	if stage == 0 and rh_pressed_ms_time == 0 and !tween.is_active():
		rh_pressed_ms_start = OS.get_ticks_msec()
		tween.interpolate_property(self,"rect_position",
		rect_position, rect_position + Vector2(-20,140) ,3, tween.TRANS_ELASTIC, tween.EASE_IN_OUT)
		tween.start()
		self.stage = 1
	if stage == 1 and rh_pressed_ms_time >= 2000 and rh_pressed_ms_time <= 4000:
		$"../TileMap".set_cell(7,4,0,false,false,false,Vector2(8,5))
	if stage == 1 and rh_pressed_ms_time >= 4000:
		$"../TileMap".set_cell(7,3,0,false,false,false,Vector2(8,5))
	if stage == 1 and Input.is_action_just_released("ui_accept"):
		$"../TileMap".set_cell(7,4,0,false,false,false,Vector2(4,4))
		$"../TileMap".set_cell(7,3,0,false,false,false,Vector2(1,1))
		tween.remove_all()
		tween.interpolate_property(self,"rect_position",
		rect_position, old_position + Vector2(-100,-50) , 0.5 , tween.TRANS_ELASTIC, tween.EASE_IN_OUT)
		tween.interpolate_property(self,"rect_position",
		old_position + Vector2(-100,-50) , old_position, 1.5 , tween.TRANS_ELASTIC, tween.EASE_IN_OUT,0.5)
		tween.start()
		emit_signal("opponent_hited",clamp(int(rh_pressed_ms_time/2000)+1,1,3))
		self.stage = 0
		rh_pressed_ms_time = 0
		rh_pressed_ms_start = 0
#урон
	if  stage == 2 :
		$"../TileMap".set_cell(7,4,0,false,false,false,Vector2(4,4))
		$"../TileMap".set_cell(7,3,0,false,false,false,Vector2(1,1))
		tween.remove_all()
		tween.interpolate_property(self,"rect_position",
		rect_position, old_position, 2 , tween.TRANS_ELASTIC, tween.EASE_IN_OUT)
		tween.start()
#		emit_signal("opponent_hited",0)
		self.stage = 0
		rh_pressed_ms_time = 0
		rh_pressed_ms_start = 0
#нет урона просто возвращвкмся сбили удар	
	


func _on_first_person_drop_the_action(target):
	if target == "printed" :
		stage = 2 
		rh_move()
	#нас сильно ударили и сбили нашу атаку
	
