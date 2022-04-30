extends Node2D

export var max_width = 8
export var max_height = 8

var rooms : Array

var _room_types : Array

# FOR ROOM PLACEMENT
var _tile_size := 16
var _room_width := 14
var _room_height := 10

enum Sides {
	HERE,
	LEFT,
	RIGHT,
	UP,
	DOWN,
	UPLEFT,
	DOWNLEFT,
	UPRIGHT,
	DOWNRIGHT
}
# Called when the node enters the scene tree for the first time.
func _ready():
	# Populate the rooms list
	var dir = Directory.new()
	var rooms_path := "res://world/rooms/" 
	dir.open(rooms_path)
	dir.list_dir_begin(true, true)
	var file_name = dir.get_next()
	while file_name != "":
		var room_scene = load(rooms_path+file_name)
		_room_types.push_back(room_scene)
		file_name = dir.get_next()
	
	#seed("poopoopeepee".hash())
	randomize()
	generate()


# When called will repopulate _rooms
func generate(num_rooms: int = 10):
	# Initialization
	var rooms_present = [[ceil(max_width/2),ceil(max_height/2)]] # rooms as a list
	var rooms_present_map = [] # rooms as a 2d array
	for i in range(max_width):
		rooms_present_map.push_back([])
		for j in range(max_height):
			if(i==ceil(max_width/2) and j==ceil(max_height/2)): # Start room
				rooms_present_map[i].push_back(true)
			else:
				rooms_present_map[i].push_back(false)
	
	# Decide which rooms are present
	var sides = get_sides()
	while rooms_present.size()<num_rooms:
		# Pick a random room and side to try to add neighbor
		var back = false
		var room
		if randf()<0.8:
			room = rooms_present.back()
			back = true
		else:
			room = rooms_present[randi()%rooms_present.size()]
		var new_room_side = sides[randi()%sides.size()]
		var new_room = [
			room[0]+new_room_side[0], 
			room[1]+new_room_side[1]]
		# Check if the new room is valid and not already taken
		if ((new_room[0]>=0 and new_room[0]<max_width) and 
			(new_room[1]>=0 and new_room[1]<max_height) and 
			(not rooms_present_map[new_room[0]][new_room[1]])):
			# Check if rooms around is acceptable
			rooms_present_map[new_room[0]][new_room[1]] = true
			if back or how_many_adjacent(rooms_present_map, new_room, get_sides([Sides.HERE]))==1:
				rooms_present.push_back([new_room[0],new_room[1]])
			else:
				rooms_present.push_front([new_room[0],new_room[1]])
	
	# Populate the rooms
	for i in range(rooms_present_map.size()):
		for j in range(rooms_present_map[0].size()):
			if(rooms_present_map[i][j]):
				print("NEW ROOM")
				var scene = _room_types[0].instance()
				add_child(scene)
				scene.global_translate(Vector2(_tile_size*_room_width*(-i+ceil(max_width)),_tile_size*_room_height*(-j+ceil(max_height))))
	####################################
	# DEBUG (print present room map)
	for i in range(max_width):
		var line = ""
		for j in range(max_height):
			if(rooms_present_map[i][j]):
				line += "[X]"
			else:
				line += "[ ]"
		print(line)
	# END OF DEBUG
	####################################
	pass


func how_many_adjacent(rooms_present_map: Array, room : Array, sides := get_sides()):
	#var sides = get_sides([Sides.HERE])
	var num_present_sides = 0
	for side in sides:
		var next_room = [
			room[0]+side[0], 
			room[1]+side[1]]
		# Check if the new room is valid
		if ((next_room[0]>=0 and next_room[0]<max_width) and 
			(next_room[1]>=0 and next_room[1]<max_height) and 
			(rooms_present_map[next_room[0]][next_room[1]])):
			num_present_sides+=1
	
	return num_present_sides


# Get a list of sides excluding those passed in ommitted
func get_sides(omit := [Sides.HERE, Sides.UPLEFT, Sides.DOWNLEFT, Sides.UPRIGHT, Sides.DOWNRIGHT]):
	var sides = [[0,0],[-1,0],[1,0],[0,-1],[0,1],[-1,-1],[-1,1],[1,-1],[1,1]]
	
	# Delete sides from omit list
	for side in omit:
		if side == Sides.HERE:
			sides.erase([0,0])
		elif side == Sides.LEFT:
			sides.erase([-1,0])
		elif side == Sides.RIGHT:
			sides.erase([1,0])
		elif side == Sides.UP:
			sides.erase([0,-1])
		elif side == Sides.DOWN:
			sides.erase([0,1])
		elif side == Sides.UPLEFT:
			sides.erase([-1,-1])
		elif side == Sides.DOWNLEFT:
			sides.erase([-1,1])
		elif side == Sides.UPRIGHT:
			sides.erase([1,-1])
		elif side == Sides.DOWNRIGHT:
			sides.erase([1,1])
	
	return sides
