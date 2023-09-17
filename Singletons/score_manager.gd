extends Node


const DEFAULT_SCORE: int = 1000


var _level_scores: Dictionary = {}
var _level_selected: int = 0
var _attempts: int = 0
var _cups_hit: int = 0
var _target_cups: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_cup_destroyed.connect(on_cup_destroyed)
	load_score()
	
	
func save_score() -> void:	
	var file = FileAccess.open("user://saved_data.sav", FileAccess.WRITE)
	if file != null:
		file.store_string(var_to_str(_level_scores))
		file.close


func load_score() -> void:
	var file = FileAccess.open("user://saved_data.sav", FileAccess.READ)
	if file != null:
		_level_scores = str_to_var(file.get_as_text())

	
func check_and_add(level: int) -> void:
	if !_level_scores.has(level):
		_level_scores[level] = DEFAULT_SCORE
				
		
func level_selected(level: int) -> void:
	check_and_add(level)
	_level_selected = level
	_attempts = 0
	_cups_hit = 0
	
	
func get_best_for_level(level: int) -> int:
	check_and_add(level)
	return _level_scores[level]
	
	
func get_attempts() -> int:
	return _attempts
	
	
func get_level_selected() -> int:
	return _level_selected
	
	
func set_target_cups(t: int) -> void:
	_target_cups = t
	
	
func attempt_made() -> void:
	_attempts += 1
	SignalManager.on_attempt_made.emit()
	
	
func check_game_over() -> void:
	if _cups_hit >= _target_cups:
		SignalManager.on_game_over.emit()
		if _level_scores[_level_selected] > _attempts:
			_level_scores[_level_selected] = _attempts
	save_score()
			


func on_cup_destroyed() -> void:
	_cups_hit += 1
	check_game_over()
