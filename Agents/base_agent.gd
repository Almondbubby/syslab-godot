extends CharacterBody2D


const SPEED = 30.0

var schedule

func _ready() -> void:
	move_to(Vector2i(10,10))
	var text_content = get_text_file_content(text_file_path)

	schedule = await Ollama.callLLM(text_content)
	print(schedule)


var text_file_path = "res://Agents/Gabriel/profile.txt"

func get_text_file_content(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	return content

var path = PackedVector2Array()

func _physics_process(delta: float) -> void:
	if path != PackedVector2Array():
		if path[0] == position:
			path.remove_at(0)
		else: 
			position = position.move_toward(path[0], delta * SPEED)

func move_to(pos):
	var astar_grid = AStarGrid2D.new()
	astar_grid.diagonal_mode = 1
	astar_grid.jumping_enabled = true
	astar_grid.region = Rect2i(0, 0, 1152, 648)
	astar_grid.update()
	path = astar_grid.get_point_path(position, pos)
		
