extends Node

var main_scene: PackedScene = preload("res://main/main.tscn")


const GROUP_CUP:  String = "cup"
const GROUP_ANIMAL:  String = "animal"

# Default star thresholds (fallback if JSON file not found)
# Format: [attempts_for_3_stars, attempts_for_2_stars]
const DEFAULT_STAR_THRESHOLDS: Dictionary = {
	1: [3, 5],
	2: [4, 6],
	3: [5, 8],
	4: [6, 10],
	5: [7, 12]
}

# Loaded star thresholds from JSON config file
var star_thresholds: Dictionary = {}


func _ready() -> void:
	load_star_thresholds()


func load_star_thresholds() -> void:
	var config_path = "res://star_thresholds.json"

	if not FileAccess.file_exists(config_path):
		print("Star thresholds config not found, using defaults")
		star_thresholds = DEFAULT_STAR_THRESHOLDS
		return

	var file = FileAccess.open(config_path, FileAccess.READ)
	if file == null:
		print("Failed to open star thresholds config, using defaults")
		star_thresholds = DEFAULT_STAR_THRESHOLDS
		return

	var json_text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_text)

	if parse_result != OK:
		print("Failed to parse star thresholds JSON, using defaults")
		star_thresholds = DEFAULT_STAR_THRESHOLDS
		return

	var data = json.data

	# Convert JSON format to internal format
	if data.has("levels"):
		for level_key in data.levels.keys():
			var level_num = int(level_key)
			var level_data = data.levels[level_key]
			star_thresholds[level_num] = [
				level_data.three_stars,
				level_data.two_stars
			]
		print("Star thresholds loaded from config file: ", star_thresholds)
	else:
		print("Invalid star thresholds config format, using defaults")
		star_thresholds = DEFAULT_STAR_THRESHOLDS


func load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)


func get_stars_for_attempts(level: int, attempts: int) -> int:
	if !star_thresholds.has(level):
		print("No star thresholds found for level ", level)
		return 1

	var thresholds = star_thresholds[level]
	if attempts <= thresholds[0]:
		return 3
	elif attempts <= thresholds[1]:
		return 2
	else:
		return 1

