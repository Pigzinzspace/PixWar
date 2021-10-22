extends Control
var monster = {
	"type": MyGlobal.monster_types.crab,
	"dance_stage":0,
	"current_damage":0
}
var damage_emited = true
var action_dropped = false

var tween
var old_rect_position = Vector2(0,0)
var old_rect_scale = Vector2(1,1)
signal opponent_attack(damage)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.


func _ready():
	
	 
	tween = $"../Tween4"
	
func start_attack_cycle():
	attack_cycle()
	$Timer.start()
	for i in 8:
		
		$"../TileMap".set_cell(i,1,0,false,false,false,monster.type.death_dance[i%monster.type.death_dance.keys().size()].cell_id)
		print(i," ",i%monster.type.death_dance.keys().size()," ",monster.type.death_dance.keys().size())
	
	

func attack_cycle():
	monster.current_damage = monster.type.death_dance[monster.dance_stage%monster.type.death_dance.keys().size()].damage
	if monster.current_damage == 0 :
		rest_animation()
	else:
		attack_animation()
	monster.dance_stage += 1
	
	
func attack_animation():
	tween.remove_all()
#это для того чтоб урон был после первого мува а не после отката 
	damage_emited = false
	
	tween.interpolate_property(self,"rect_position",
	rect_position, rect_position+Vector2(-15*monster.current_damage,40) ,3, tween.TRANS_ELASTIC, tween.EASE_IN_OUT,1)
	tween.interpolate_property(self,"rect_position",
	rect_position+Vector2(-15*monster.current_damage,40), old_rect_position, 1, tween.TRANS_LINEAR, tween.EASE_IN,4)
	tween.interpolate_property(self,"rect_scale",
	rect_scale, rect_scale*(1+monster.current_damage*0.1) ,3, tween.TRANS_ELASTIC, tween.EASE_IN_OUT,1)
	tween.interpolate_property(self,"rect_scale",
	rect_scale*(1+monster.current_damage*0.1), old_rect_scale, 1, tween.TRANS_LINEAR, tween.EASE_IN,4)
	tween.start()
	
func rest_animation():
	tween.remove_all()
	tween.interpolate_property(self,"rect_position",
	rect_position, rect_position+Vector2(20,0) ,1, tween.TRANS_ELASTIC, tween.EASE_IN)
	tween.interpolate_property(self,"rect_position",
	rect_position+Vector2(20,0), rect_position-Vector2(30,0),1, tween.TRANS_ELASTIC, tween.EASE_IN,1)
	tween.interpolate_property(self,"rect_position",
	rect_position-Vector2(30,0), rect_position+Vector2(40,0),1, tween.TRANS_ELASTIC, tween.EASE_IN,2)
	tween.interpolate_property(self,"rect_position",
	rect_position+Vector2(40,0), rect_position-Vector2(20,0),1, tween.TRANS_ELASTIC, tween.EASE_IN,3)
	tween.interpolate_property(self,"rect_position",
	rect_position-Vector2(20,0), old_rect_position, tween.TRANS_ELASTIC, tween.EASE_IN,4)
	tween.interpolate_property(self,"rect_scale",
	rect_scale, rect_scale*1.1 ,3, tween.TRANS_ELASTIC, tween.EASE_IN,1)
	tween.interpolate_property(self,"rect_scale",
	rect_scale*1.1, old_rect_scale, 1, tween.TRANS_LINEAR, tween.EASE_IN,4)
	
	tween.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	attack_cycle()
	pass # Replace with function body.

func _on_Tween4_tween_completed(object, key):
	if !damage_emited and monster.current_damage != 0 :
		if action_dropped :
			 action_dropped = false
		else:
			emit_signal("opponent_attack",monster.current_damage)
			
		damage_emited = true

func _on_first_person_drop_the_action(target):
	if target == "opponent" and monster.current_damage > 1:
		action_dropped = true	
	
