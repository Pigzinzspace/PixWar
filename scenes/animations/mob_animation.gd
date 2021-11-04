extends Node2D
#этот нод не учитывает хп или урон только анимацию, 
# он умееет запускать по вызову set_new_action(action) анимацию
# и сообщать что она закончилась сигналом action_ended(action) 
# а так же прирывать анимацию   force_stop_action() 
# если эту анимацию можно прервать моб зациклится в IDLE акции, и будет слать сигналы каждый цикл 

onready var animation_tree = $Position2D/AnimationTree 
var current_tree_action = 0 
var start_time = 0 
signal action_ended(action)	
const animation_stopble = {
	MyGlobal.mob_tree_action.MEDIUM_ATTACK : 1000,
	MyGlobal.mob_tree_action.STRONG_ATTACK : 1500
}
const animation_to_mob_tree_action = {
	"idle": MyGlobal.mob_tree_action.IDLE,
	"panic": MyGlobal.mob_tree_action.PANIC,
	"basic_attack" : MyGlobal.mob_tree_action.BASIC_ATTACK,
	"medium_attack" : MyGlobal.mob_tree_action.MEDIUM_ATTACK,
	"strong_attack" : MyGlobal.mob_tree_action.STRONG_ATTACK,
	"death" : MyGlobal.mob_tree_action.DEATH
}

#заного загружает параметры монстра и его картинку в атлас должен быть передан дупликат текстуры
func mob_reload(mob_id,pix_size,row_length,atlas=null):
	var current_tree_action = 0
	var start_time = 0
	var atlas_y = mob_id/row_length*pix_size 
	var atlas_x = mob_id%row_length*pix_size 
	var sprite_scale = 20.0*8/pix_size 
	var mob_sprite = $Position2D/mob/Sprite
	if atlas != null :
		atlas.region = Rect2(atlas_x,atlas_y,pix_size,pix_size)
		mob_sprite.texture = atlas
	else : 
		mob_sprite.texture.region = Rect2(atlas_x,atlas_y,pix_size,pix_size)
		mob_sprite.scale = Vector2(sprite_scale,sprite_scale)
	

#запускает в дереве анимации новую анимацию, устанавливает current_tree_action и счетчик времени start_time если ее можно сбить 
func set_new_action(action):
	var attacks = animation_tree["parameters/attacks/playback"]
	match action:
		MyGlobal.mob_tree_action.IDLE :
			animation_tree["parameters/Transition/current"] = 0
			attacks.travel("idle")
			current_tree_action = MyGlobal.mob_tree_action.IDLE 
		MyGlobal.mob_tree_action.PANIC :
			animation_tree["parameters/Transition/current"] = 0
			attacks.travel("panic")
			current_tree_action = MyGlobal.mob_tree_action.PANIC
		MyGlobal.mob_tree_action.BASIC_ATTACK :
			animation_tree["parameters/Transition/current"] = 0
			attacks.travel("")
			current_tree_action = MyGlobal.mob_tree_action.BASIC_ATTACK
		MyGlobal.mob_tree_action.MEDIUM_ATTACK :
			animation_tree["parameters/Transition/current"] = 0
			attacks.travel("")
#эту анимацию можно сбить по этому засекаем время когда она началась 
			start_time = OS.get_ticks_msec()
			current_tree_action = MyGlobal.mob_tree_action.MEDIUM_ATTACK 
		MyGlobal.mob_tree_action.STRONG_ATTACK :
			animation_tree["parameters/Transition/current"] = 0
			attacks.travel("")
			start_time = OS.get_ticks_msec()
			current_tree_action = MyGlobal.mob_tree_action.STRONG_ATTACK
		MyGlobal.mob_tree_action.DEATH :
			animation_tree["parameters/Transition/current"] = 1
			current_tree_action = MyGlobal.mob_tree_action.DEATH
	
#проверяет счетчик времени, и сбрасывает анимацию если ее можно сбить, если удачно прекращена анимация атаки возвращает ture
func force_stop_action()->bool:
	if animation_stopble.has(current_tree_action):
		var delta_time = OS.get_ticks_msec()-start_time
		if animation_stopble[current_tree_action] >= delta_time:
			set_new_action(MyGlobal.mob_tree_action.IDLE)
			return true
		else :
			return false
	else:
		return false

#обрабатывает сигнал завершения анимации и издучает его силу (dance) если это атака если нет излучает силу нулевой атаки
func _ready():
	mob_reload(13,8,14)



func _on_AnimationPlayer_animation_finished(anim_name):
#если кончилась анимация walk это нас не волнует - это шум, обо всех остальных сообщаем сигналом
	if anim_name != "walk" :
		emit_signal("action_ended",animation_to_mob_tree_action[anim_name])
	
