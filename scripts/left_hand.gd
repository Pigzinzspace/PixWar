extends Control
var lh_pressed_ms_time = 0
var lh_pressed_ms_start = 0
var old_position = Vector2(-3,221)
var stage setget stage_set
var tween 
signal shield_up(status)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func stage_set(value):
	if value == 0 and $"../..".printed.stamina>0:
		$lh_TextureRect.material.set_shader_param("outline_width",0.2)
	else:
		$lh_TextureRect.material.set_shader_param("outline_width",0)
	stage = value

# Called when the node enters the scene tree for the first time.
func _ready():
	old_position = rect_position
	tween = $"../Tween3"

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		var mouse_xy = get_local_mouse_position()
		if stage == 1:
			lh_move()
		elif stage in [0,2] and mouse_xy.x>=0 and mouse_xy.x<= rect_size.x and mouse_xy.y>=0 and mouse_xy.y<= rect_size.y:
			lh_move()	
	elif Input.is_action_just_released("ui_accept"):
		if stage == 1:
			lh_move()
			
			
func lh_move():
	if stage != 0:
		lh_pressed_ms_time = OS.get_ticks_msec() - lh_pressed_ms_start
	if stage == 0 and lh_pressed_ms_time == 0 and !tween.is_active():
		lh_pressed_ms_start = OS.get_ticks_msec()
		tween.interpolate_property(self,"rect_position",
		rect_position, rect_position + Vector2(20,-80) ,1, tween.TRANS_ELASTIC, tween.EASE_IN_OUT)
		$"../TileMap".set_cell(0,4,0,false,false,false,Vector2(8,5))
		tween.start()
		self.stage = 1
		emit_signal("shield_up",1)
		
#урон
	if  stage == 2 :
		tween.interpolate_property(self,"rect_position",
		rect_position, old_position ,2, tween.TRANS_ELASTIC, tween.EASE_IN_OUT)
		$"../TileMap".set_cell(0,4,0,false,false,false,Vector2(1,1))
		tween.start()
		emit_signal("shield_up",0)
		self.stage = 0
		lh_pressed_ms_time = 0
		lh_pressed_ms_start = 0
		
	if stage == 1 and Input.is_action_just_released("ui_accept"):
		self.stage = 2
#нет урона просто возвращвкмся сбили удар	
