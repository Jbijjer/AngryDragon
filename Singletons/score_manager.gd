extends Node


const DEFAULT_SCORE: int = 1000


var _level_scores: Dictionary = {}
var _level_stars: Dictionary = {}
var _level_selected: int = 0
var _attempts: int = 0
var _cups_hit: int = 0
var _target_cups: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_cup_destroyed.connect(on_cup_destroyed)
	load_score()
	
	
func save_score() -> void:
	var save_data = {
		"scores": _level_scores,
		"stars": _level_stars
	}
	var file = FileAccess.open("user://saved_data.sav", FileAccess.WRITE)
	if file != null:
		file.store_string(var_to_str(save_data))
		file.close


func load_score() -> void:
	var file = FileAccess.open("user://saved_data.sav", FileAccess.READ)
	if file != null:
		var data = str_to_var(file.get_as_text())
		# Handle old save format (just scores)
		if data is Dictionary and data.has("scores"):
			_level_scores = data.scores
			_level_stars = data.stars if data.has("stars") else {}
		else:
			# Old format: just the scores dictionary
			_level_scores = data if data is Dictionary else {}
			_level_stars = {}

	
func check_and_add(level: int) -> void:
	if !_level_scores.has(level):
		_level_scores[level] = DEFAULT_SCORE
	if !_level_stars.has(level):
		_level_stars[level] = 0
				
		
func level_selected(level: int) -> void:
	check_and_add(level)
	_level_selected = level
	_attempts = 0
	_cups_hit = 0
	
	
func get_best_for_level(level: int) -> int:
	check_and_add(level)
	return _level_scores[level]


func get_stars_for_level(level: int) -> int:
	check_and_add(level)
	return _level_stars[level]


func is_level_completed(level: int) -> bool:
	check_and_add(level)
	return _level_stars[level] > 0


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
		# Calculate stars for current attempts
		var stars = GameManager.get_stars_for_attempts(_level_selected, _attempts)

		# Update best score if this is better
		if _level_scores[_level_selected] > _attempts:
			_level_scores[_level_selected] = _attempts

		# Update stars if this is better
		if _level_stars[_level_selected] < stars:
			_level_stars[_level_selected] = stars

		SignalManager.on_game_over.emit()
	save_score()
			


func on_cup_destroyed() -> void:
	_cups_hit += 1
	check_game_over()
