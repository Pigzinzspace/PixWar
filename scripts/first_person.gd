extends Node2D

var room_lvl = 0
var opponent = {"monster":MyGlobal.monster_types.crab, 
"hp":MyGlobal.monster_types.crab.hp
}
var printed = { "hit_points":16,
"stamina":16,
"shield_up":0, 
"left_hand":MyGlobal.items.shield,
"right_hand":MyGlobal.items.short_sword,
}
var tween 
signal drop_the_action(target)


func load_a_duel(monster,level,the_printed):
	room_lvl = level
	opponent.monster = monster
	opponent.hp = monster.hp
	$Control/opponent.monster.type = opponent.monster
	$Control/opponent.monster.dance_stage = 0
	$Control/opponent.monster.current_damage = 0
	
	
	room_lvl = level
	printed.hit_points = the_printed.hit_points
	printed.stamina = the_printed.stamina
	printed.shield_up = 0 
	printed.left_hand = the_printed.left_hand
	printed.right_hand = the_printed.right_hand 
	
	$Control/left_hand/lh_TextureRect.texture = MyGlobal.load_tile_by_index(printed.left_hand.tile_id)
	$Control/left_hand.stage = 0
	$Control/right_hand/rh_TextureRect.texture = MyGlobal.load_tile_by_index(printed.right_hand.tile_id)
	$Control/right_hand.stage = 0
	
	
	$Control/opponent/opponent.texture = MyGlobal.load_tile_by_index(opponent["monster"].tile_id)
	$Control/opponent.start_attack_cycle()
	nois()

func _ready():
	
	tween = $Control/Tween


	
	
	


func nois():
	var left_hand = $Control/left_hand/lh_TextureRect
	var left_hand_position = $Control/left_hand/lh_TextureRect.rect_position
	var right_hand = $Control/right_hand/rh_TextureRect
	var right_hand_position = $Control/right_hand/rh_TextureRect.rect_position
	var right_hand_rotation = $Control/right_hand/rh_TextureRect.rect_rotation
	
	
	
	

	tween.interpolate_property(right_hand,"rect_rotation",
	right_hand_rotation, right_hand_rotation+7 ,3, tween.TRANS_BACK, tween.EASE_IN)
	tween.interpolate_property(right_hand,"rect_rotation",
	right_hand_rotation +7, right_hand_rotation ,3, tween.TRANS_LINEAR, tween.EASE_IN,3)
	
	
	tween.interpolate_property(left_hand,"rect_position",
	left_hand_position, left_hand_position+Vector2(5,-20) ,3, tween.TRANS_SINE, tween.EASE_IN)
	tween.interpolate_property(left_hand,"rect_position",
	left_hand_position+Vector2(5,-20), left_hand_position ,3, tween.TRANS_LINEAR, tween.EASE_IN,3)
	
	
#	tween.interpolate_property(right_hand,"rect_position",
#	right_hand_position, right_hand_position+Vector2(-30,6) ,4, tween.TRANS_LINEAR, tween.EASE_IN)
	tween.start()




func _on_rh_TextureRect_gui_input(event):
	pass # Replace with function body.


func _on_Tween_tween_all_completed():
	nois()
	pass # Replace with function body.


func _on_right_hand_opponent_hited(damage):
	update_stats("opponent","hp",-damage)
	update_stats("printed","stamina",-1)
	pass # Replace with function body.


func _on_opponent_opponent_attack(damage):
	update_stats("printed","hit_points",-damage)
	
	pass # Replace with function body.


func _on_left_hand_shield_up(status):
	if status == 1 :
		printed.shield_up = 1
		update_stats("printed","stamina",-1)
		
		$Timer.start()
	else:
		printed.shield_up = 0
		$Timer.stop()
		
		
	pass # Replace with function body.

func update_stats(who,stat,value):
	match who:
		"printed":
			match stat:
				"hit_points":
					hit_animation("printed")
					if 0-value-printed.shield_up > 1:
						emit_signal("drop_the_action","printed")
						printed.hit_points += (value+printed.shield_up-room_lvl)
					elif 0-value-printed.shield_up == 1:
#если щит поднят средняя атака никогда не сбивает каст, хотя и уменьшает урон только на 1, можно получить 10 урона но продолжить атаку
#аналогично если щит поднят слабая атака никогда не наносит урон даже если ее номинал 10
						printed.hit_points += (value+printed.shield_up-room_lvl)
					
#помним что value урона меньше нуля по этому прибавляем к HP а 
					if printed.hit_points <= 0 :
						monster_killed()
				"stamina":
					printed.stamina += value
					if printed.stamina <= 0 and printed.shield_up == 1:
						$Control/left_hand.stage=2
						$Control/left_hand.lh_move()
						printed.shield_up=0
						$Timer.stop()
		"opponent":
			hit_animation("opponent")
			if printed.stamina <= 0 or -value == 1:
					opponent.hp -=1
			else:
				if 0-value > 1:
					opponent.hp += value
					emit_signal("drop_the_action","opponent")
			
	for i in 4:
		if int(printed.hit_points+3)/4-i <= 0: 
			$Control/TileMap.set_cell(i,0,0,false,false,false,Vector2(1,1))
		else:
			$Control/TileMap.set_cell(i,0,0,false,false,false,Vector2(6,6))
#	for i in 4:
#		$Control/TileMap.set_cell(i,0,0,false,false,false,Vector2(6,6)*clamp(int(printed.hit_points+3)/4-i,0,1)+Vector2(1,1)*clamp(int(15-printed.hit_points)/4 - (3-i),0,1))
	for i in 4:
		if int(printed.stamina+3)/4-i <= 0: 
			$Control/TileMap.set_cell(i+4,0,0,false,false,false,Vector2(1,1))
		else:
			$Control/TileMap.set_cell(i+4,0,0,false,false,false,Vector2(1,7))
			
			
	MyGlobal.save_printed_stats(printed)
#если мы еще живы апдейтим меню
	MyGlobal.update_room_menu()



func _on_Timer_timeout():
	update_stats("printed","stamina",-1)
	pass # Replace with function body.




func _on_Timer2_timeout():
	update_stats("printed","stamina",1)
	pass # Replace with function body.


func hit_animation(who):
	if who == "opponent":
#		print("hit_animation opponent")
		var tween_red = $Control/Tween5
		tween_red.interpolate_property($Control/opponent/opponent.material,"shader_param/flash_modifier",
		0.0,1.0, 0.05, tween_red.TRANS_LINEAR, tween_red.EASE_IN)
		tween_red.interpolate_property($Control/opponent/opponent.material,"shader_param/flash_modifier",
		0.1,0.0, 0.05, tween_red.TRANS_LINEAR, tween_red.EASE_IN,0.1)
# ждем пока пройдет анимация удара, меч дойдет до цели
		yield(get_tree().create_timer(0.4), "timeout")
		tween_red.start()
		
	
	

func monster_killed():
	pass





