extends Node2D

@export var spawn_units: PackedScene
@export var spawn_units_amount: int
@export var spawn_units_max_amount: int
@export var spawn_time_intervall: float
var spawned_units = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawn_timer = $SpawnTimer
	spawn_timer.wait_time = spawn_time_intervall
	spawn_timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(spawned_units.size() - 1, -1, -1):  # Schleife rückwärts
		if not spawned_units[i].is_instance_valid():
			spawned_units.remove(i)

func _on_spawn_timer_timeout() -> void:
	var current_amount = spawned_units.size()
	var remaining_to_spawn = spawn_units_max_amount - current_amount

	if remaining_to_spawn > 0:
		var amount_to_spawn = min(spawn_units_amount, remaining_to_spawn)
		print("Time to spawn")
		var npc = spawn_units.instantiate()
		for i in range(amount_to_spawn):
			npc.position = position
			if get_parent():
				get_parent().add_child(npc)
			else:
				print("No Parent found: Spawner")
