extends Node2D

@export var spawn_units: Array[PackedScene] = []
@export var spawn_units_amount: int
@export var spawn_units_max_amount: int
@export var spawn_time_intervall: float
@export var spawn_area: Polygon2D

var active_units_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var spawn_timer = $SpawnTimer
	spawn_timer.wait_time = spawn_time_intervall
	spawn_timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	var remaining_to_spawn = spawn_units_max_amount - active_units_count
	var spawn_unit = choose(spawn_units)

	if remaining_to_spawn > 0:
		var amount_to_spawn = min(spawn_units_amount, remaining_to_spawn)
		for i in range(amount_to_spawn):
			var npc = spawn_unit.instantiate()
			var spawn_point = get_random_position_within_polygon()
			npc.position = spawn_point
			if get_parent():
				get_parent().add_child(npc)
				npc.connect("unit_removed", Callable(self, "_on_unit_removed"))
				print("Spawning unit..")
				active_units_count += 1
			else:
				print("No Parent found: Spawner")
		print(str(spawn_units_amount) + " Unit/s spawned: " + str(spawn_unit))
	else:
		print("Max Amount of Units reached")
		
func _on_unit_removed():
	print("Unit removed")
	active_units_count -= 1

func choose(array):
	array.shuffle()
	return array.front()

func get_random_position_within_polygon() -> Vector2:
	if spawn_area and spawn_area.polygon.size() > 0:
		var attempts = 0
		var max_attempts = 100
		var spawn_point = position  # Standardposition als Fallback
		
		while attempts < max_attempts:
			var min_x = spawn_area.polygon[0].x
			var max_x = spawn_area.polygon[0].x
			var min_y = spawn_area.polygon[0].y
			var max_y = spawn_area.polygon[0].y
			
			for point in spawn_area.polygon:
				min_x = min(min_x, point.x)
				max_x = max(max_x, point.x)
				min_y = min(min_y, point.y)
				max_y = max(max_y, point.y)

			var random_point = Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))
			if point_in_polygon(random_point, spawn_area.polygon):
				return random_point  # Rückgabe der gültigen Position

			attempts += 1
		
		# Wenn keine gültige Position gefunden wird, Rückgabe der Standardposition
		return spawn_point

	return position  # Fallback, falls nichts funktioniert


func point_in_polygon(point: Vector2, polygon: Array) -> bool:
	var inside = false
	var j = polygon.size() - 1
	for i in range(polygon.size()):
		if (polygon[i].y > point.y) != (polygon[j].y > point.y) and (point.x < (polygon[j].x - polygon[i].x) * (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x):
			inside = !inside
		j = i
	return inside
