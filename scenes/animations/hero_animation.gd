extends Node2D

#этот нод не учитывает хп или урон только анимацию, 
# он умееет запускать по вызову set_new_action(action) анимацию
# и сообщать что она закончилась сигналом action_ended(action) 
# а так же прирывать анимацию   force_stop_action() 
# если эту анимацию можно прервать моб зациклится в IDLE акции, и будет слать сигналы каждый цикл 

onready var animation_tree = $body/AnimationTree 
var current_tree_action = {
# value : start time
}

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



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
