extends Position2D
onready var animation_tree = $AnimationTree
enum tree_action { IDLE,PANIC,BASIC_ATTACK,MEDIUM_ATTACK,STRONG_ATTACK,DEATH}
var current_tree_action = tree_action.IDLE
var start_time = 0 
var deth_dence = {}

#заного загружает все параметры монстра
func mob_reload(mob_deth_dence,mob_id):
	
	pass

#запускает в дереве анимации новую анимацию, устанавливает current_tree_action и счетчик времени start_time если ее можно сбить 
func set_new_action(action):
	pass
	
#проверяет щетчик времени, и сбрасывает анимацию если ее можно сбить, если удачно возвращает ture
func force_stop_action()->bool:
	return true; 

#обрабатывает сигнал завершения анимации и издучает его силу (dance) если это атака если нет излучает силу нулевой атаки
signal action_ended(dance)	

func _ready():
#	var attacks = animation_tree["parameters/attacks/playback"]
#	attacks.travel("panic")
#	animation_tree["parameters/Transition/current"] = 1
	pass # Replace with function body.



