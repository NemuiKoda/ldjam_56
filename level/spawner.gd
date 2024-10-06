extends Node2D

# Das zu spawnende Node (z. B. eine Kapsel)
var node_to_spawn: PackedScene
var spawn_polygon: Array  # Ändere hier zu Array
var max_nodes = 10  # Maximale Anzahl an Nodes
var spawned_nodes = []  # Liste der aktuell gespawnten Nodes
var spawnIntervallTime = 1.0

func _ready():
	# Hole das Polygon von der Kind-Node (angenommen, es heißt "spawnarea")
	var polygon_node = $spawnarea # Stelle sicher, dass der Name übereinstimmt
	spawn_polygon = polygon_node.polygon

	# Lade die Szene, die gespawnt werden soll
	node_to_spawn = preload("res://entitys/slime/green_slime.tscn")

	# Spawne den Node
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = spawnIntervallTime
	spawn_timer.autostart = true
	spawn_timer.connect("timeout", Callable(self, "spawn_node"))  # Verwende Callable
	add_child(spawn_timer)

func spawn_node():
	# Prüfe, ob weniger als max_nodes gespawnt sind
	if spawned_nodes.size() >= max_nodes:
		return  # Nicht mehr spawnen, wenn max_nodes erreicht ist

	var random_position: Vector2
	var attempts = 0
	var max_attempts = 100

	# Berechne die Grenzen des Polygons
	var min_x = spawn_polygon[0].x
	var max_x = spawn_polygon[0].x
	var min_y = spawn_polygon[0].y
	var max_y = spawn_polygon[0].y

	for point in spawn_polygon:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)

	# Versuche, eine gültige Position zu finden
	while attempts < max_attempts:
		random_position = Vector2(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y)
		)

		if is_position_in_polygon(random_position, spawn_polygon):
			var new_node = node_to_spawn.instantiate()  # Verwende instantiate() in Godot 4
			new_node.position = random_position
			new_node.connect("tree_exited", Callable(self, "on_node_removed"))  # Kein dritter Parameter notwendig
			add_child(new_node)
			spawned_nodes.append(new_node)  # Füge den neuen Node zur Liste hinzu
			return # Beende die Funktion, wenn der Node erfolgreich gespawnt wurde

		attempts += 1

	print("Keine gültige Position gefunden!")


# Prüft, ob eine Position im Polygon liegt
func is_position_in_polygon(point: Vector2, polygon: Array) -> bool:
	var is_inside = false
	var j = polygon.size() - 1

	for i in range(polygon.size()):
		if (polygon[i].y > point.y) != (polygon[j].y > point.y) and (point.x < (polygon[j].x - polygon[i].x) * (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x):
			is_inside = !is_inside
		j = i

	return is_inside

# Callback, wenn ein Node entfernt wurde
func on_node_removed(node):
	spawned_nodes.erase(node)  # Entferne den Node aus der Liste
