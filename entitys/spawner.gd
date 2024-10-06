extends Node2D

@export var spawn_units: Array[PackedScene] = []
@export var spawn_units_amount: int
@export var spawn_units_max_amount: int
@export var spawn_time_intervall: float

@onready var spawn_area: Area2D = $SpawnArea

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
			npc.position = position
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
	print("Unit removed: Spawner")
	active_units_count -= 1

func choose(array):
	array.shuffle()
	return array.front()
