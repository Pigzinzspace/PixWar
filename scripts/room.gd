extends Node2D
var room_namber  = ""
var room_lvl = 0
var room_lvl_up = 0
var room_reward = "normal"
#зависит от того сколько дверей было открыто перед этой дверью, дополнительный параметр редкости для нахождения 
#особенных мест секретов редкого дропа и наград
var deeper = 0
var key_selected = false
var key_cell
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_room("0",0)
	pass # Replace with function body.




func generate_room(room_name,lvl):
	var node_children = $Control.get_children()
	var k = 0
	while k < node_children.size() :
		if node_children[k].is_in_group("cells") :
			node_children[k].queue_free()
		k += 1
	key_selected = false
	room_namber = room_name
	room_lvl = lvl
	MyGlobal.saved_rooms[str(room_namber)] = {"room_lvl":room_lvl,"opened_door":{}}
#это надо чтоб при возвращении обратно не проверять через какую дверь мы зашли, и будет убрано потом
# так как всеравно не работает при телепорте, - уровень комнаты надо сохранять 
	

#удалить все старое
	var my_cell = load("res://scenes/room_cell.tscn")
	var room_exit = my_cell.instance()
	room_exit.cell_name = room_name
	room_exit.cell_type = MyGlobal.room_cells_types["door"]
	room_exit.cell_sub_type = MyGlobal.door_types["exit_door"]
	room_exit.cell_tile_id = room_exit.cell_sub_type["tile_id"]
	room_exit.position = Vector2(0,0)
	$Control.add_child(room_exit)
	seed(room_name.hash())
	
	for i in range(1,16):
		var  cell = my_cell.instance()
		match i:
			10:cell.cell_name = "A"
			11:cell.cell_name = "B"
			12:cell.cell_name = "c"
			13:cell.cell_name = "D"
			14:cell.cell_name = "E"
			15:cell.cell_name = "F"
			_:cell.cell_name = str(i)
		cell.cell_type = MyGlobal.room_cells_types["door"]
		match randi()%4 :
			0 : 
				cell.cell_sub_type = MyGlobal.door_types["door_down"]
				cell.cell_tile_id = cell.cell_sub_type["tile_id"]
				cell.position = Vector2(i%8*60,i/8*60)
			1 :
				cell.cell_sub_type = MyGlobal.door_types["door"]
				cell.cell_tile_id = cell.cell_sub_type["tile_id"]
				cell.position = Vector2(i%8*60,i/8*60)
			2 :
				cell.cell_sub_type = MyGlobal.door_types["closed_door_down"]
				cell.cell_tile_id = cell.cell_sub_type["tile_id"]
				cell.position = Vector2(i%8*60,i/8*60)
			3 :
				cell.cell_sub_type = MyGlobal.door_types["closed_door"]
				cell.cell_tile_id = cell.cell_sub_type["tile_id"]
				cell.position = Vector2(i%8*60,i/8*60)
		$Control.add_child(cell)
#генерируем мобов
	var mob_count = 0
	match randi()%20 :
		0: 
			pass
		1:
			mob_count = randi()%10+3
			room_reward = "epic"
		2,3:
			mob_count = randi()%3+3
			room_reward = "rare"
		4,5:
			mob_count = 2
		_:
				mob_count = 1
	var mobs = MyGlobal.monster_types.keys()
	for j in  mob_count:
		var mob_cell = my_cell.instance()
		var mob_key = mobs[randi() % mobs.size()]
		mob_cell.cell_name = mob_key
		mob_cell.cell_type = MyGlobal.room_cells_types["monster"]
		mob_cell.cell_sub_type = MyGlobal.monster_types[mob_key]
		mob_cell.cell_tile_id = mob_cell.cell_sub_type["tile_id"]
		mob_cell.position = Vector2(60+j%6*60,180+j/6*60)
		$Control.add_child(mob_cell)
#генерируем станки
	var benches = MyGlobal.machine_types.keys()
	for j in benches.size() :
		if randi()%10  <= 0 :
			var bench_cell = my_cell.instance()
			bench_cell.cell_name = benches[j]
			bench_cell.cell_type = MyGlobal.room_cells_types["machine"]
			bench_cell.cell_sub_type = MyGlobal.machine_types[benches[j]]
			bench_cell.cell_tile_id = bench_cell.cell_sub_type["tile_id"]
			bench_cell.position = Vector2(60+j%6*60,360+j/6*60)
			$Control.add_child(bench_cell)
#	кнопка ключей и кнопка еды всегда стоят на своем месте 		
	for key in ["keys","food"]:
		var menu_cell = my_cell.instance()
		menu_cell.cell_name = key
		menu_cell.cell_type = MyGlobal.room_cells_types["menu"]
		menu_cell.cell_sub_type = MyGlobal.menu_types[key]
		menu_cell.cell_tile_id = menu_cell.cell_sub_type["tile_id"]
		match key:
			"keys":
				menu_cell.position = Vector2(0,7*60)
			"food":
				menu_cell.position = Vector2(2*60,7*60)
		$Control.add_child(menu_cell)
			
func cell_pressed(cell):
	match cell.cell_type :
		MyGlobal.room_cells_types.monster:
			MyGlobal.first_person_scene.load_a_duel(cell.cell_sub_type,room_lvl, MyGlobal.printed)
		MyGlobal.room_cells_types.menu:
			match cell.cell_sub_type:
				MyGlobal.menu_types.keys:
					if key_selected :
						key_selected = false
						key_cell.unselect()
					else:
						key_selected = true
						key_cell = cell
						key_cell.select()
				MyGlobal.menu_types.food:
					pass
		MyGlobal.room_cells_types.door:
			print(room_namber," ",cell.cell_name)
			if cell.cell_name == room_namber :
#мы возвращаемся, откусим одну букву слева у имени комнаты, а уровень возьмем из словаря
				if room_namber == "0" : 
					return #из корня не выйти
				var old_room_namber = room_namber.right(1)
				generate_room(old_room_namber,MyGlobal.saved_rooms[old_room_namber].room_lvl)
			match cell.cell_sub_type:
				MyGlobal.door_types.closed_door_down,MyGlobal.door_types.closed_door:
					if key_selected and MyGlobal.check_keys(room_lvl):
#это закрытые дверь или закрытая дверь вниз и выбран ключ    
						if cell.cell_sub_type == MyGlobal.door_types.closed_door_down :
							generate_room(str(cell.cell_name)+str(room_namber),room_lvl+1)
						else:
							generate_room(str(cell.cell_name)+str(room_namber),room_lvl)
						
				MyGlobal.door_types.door_down:
					
					generate_room(str(cell.cell_name)+str(room_namber),room_lvl+1)
				MyGlobal.door_types.door:
					generate_room(str(cell.cell_name)+str(room_namber),room_lvl)
		_:
			print(cell.cell_name)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
