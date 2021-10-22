extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	MyGlobal.room_scene = load('res://scenes/room.tscn').instance()
	MyGlobal.room_scene.position = Vector2(0,0)
	add_child(MyGlobal.room_scene)
	
	MyGlobal.first_person_scene = load('res://scenes/first_person.tscn').instance()
	MyGlobal.first_person_scene.position = Vector2(480,0)
	add_child(MyGlobal.first_person_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
