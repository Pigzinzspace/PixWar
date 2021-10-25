extends Node
var room_scene 
var first_person_scene 

#нпс и итемов пока нет
var room_cells_types = {"door":"door","monster":"monster","NPC":"NPC","item":"item","machine":"machine","menu":"menu"}
var door_types = {"exit_door": {"tile_id":30} ,
"door_down":{"tile_id":46},
"closed_door_down":{"tile_id":32},
"closed_door":{"tile_id":32},
"door":{"tile_id":33}
}
var machine_types = {"mine":{"tile_id":136},
"science":{"tile_id":49},
"sintez":{"tile_id":29},
"farm":{"tile_id":61},
"monster_farm":{"tile_id":103},
"rest":{"tile_id":121}
}
var menu_types = {"keys":{"tile_id":80},
"food":{"tile_id":122}
}
var dances = {
	0:{"damage":0,"cell_id":Vector2(1,1)},
	1:{"damage":1,"cell_id":Vector2(2,10)},
	2:{"damage":2,"cell_id":Vector2(1,10)},
	3:{"damage":3,"cell_id":Vector2(0,10)}
	} 
var monster_types = {
"rat":{"tile_id":20,"hp":16,"death_dance":{0:dances[1],1:dances[2],2:dances[3],3:dances[0]}},
"dog":{"tile_id":19,"hp":16,"death_dance":{0:dances[1],1:dances[2],2:dances[1],3:dances[2]}},
"crab":{"tile_id":12,"hp":16,"death_dance":{0:dances[1],1:dances[2],2:dances[0],3:dances[3],4:dances[0]}},
"beholder":{"tile_id":13,"hp":16,"death_dance":{0:dances[2]}}
}
var items = {"short_sword":{"name":"short sword","tile_id":62},
"shield":{"name":"shield","tile_id":93}}

var NPCs = {"test_NPC":"Vasya"}
var printed = { "hit_points":16,
"stamina":16,
"left_hand":items.shield,
"right_hand":items.short_sword, 
"door_keys": 300, 
"food": 300
}

#словарь индексов силы урона которые называются танец от 0 и до фига

 
#структура заполняется ноде рум в процедуре генерации комнат и хранит данные,
# которые неаозможно восстановить при генерации по ключу, например уровень комнаты
# который зависит от того сколько случайных дверей вниз прошел игрок
  
var saved_rooms = {}

var load_atlas_texture = AtlasTexture.new() 
var ITEM_HEIGHT
var ITEM_WIDTH
var ITEM_PER_ROW

func _ready():
	load_atlas_texture.atlas = load("res://sprites/colored_tilemap_packed1.png")
	ITEM_HEIGHT = 8
	ITEM_WIDTH = 8
	ITEM_PER_ROW=14
	pass # Replace with function body.

func save_printed_stats(room_printed):
	printed.stamina = room_printed.stamina
	printed.hit_points = room_printed.hit_points
	
	pass

func update_room_menu():
	room_scene.get_node("Control/Label").text = str(printed.door_keys)
	room_scene.get_node("Control/Label2").text = str(printed.food)
	room_scene.get_node("Control/Label3").text = str(printed.hit_points)
	room_scene.get_node("Control/Label4").text = str(printed.stamina)	
	
	

	
func check_keys(keys_count)->bool:
	if printed.door_keys >= keys_count:
		printed.door_keys -= keys_count+1 #самый маленький уровень 0
		update_room_menu()
		return true
	else:
		return false


func load_tile_by_index(tile_index)->Object:
	var atlas_texture = load_atlas_texture.duplicate()
	atlas_texture.region = Rect2(tile_index % ITEM_PER_ROW * ITEM_WIDTH,
	tile_index / ITEM_PER_ROW * ITEM_HEIGHT,
	ITEM_WIDTH,
	ITEM_HEIGHT)
	return atlas_texture
