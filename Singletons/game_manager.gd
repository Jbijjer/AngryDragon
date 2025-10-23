extends Node

var main_scene: PackedScene = preload("res://main/main.tscn")


const GROUP_CUP:  String = "cup"
const GROUP_ANIMAL:  String = "animal"

# Star thresholds for each level: [3_stars, 2_stars]
# If attempts <= 3_stars: get 3 stars
# If attempts <= 2_stars: get 2 stars
# Otherwise: get 1 star
const STAR_THRESHOLDS: Dictionary = {
	1: [3, 5],
	2: [4, 6],
	3: [5, 8],
	4: [6, 10],
	5: [7, 12]
}


func load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)


func get_stars_for_attempts(level: int, attempts: int) -> int:
	if !STAR_THRESHOLDS.has(level):
		return 1

	var thresholds = STAR_THRESHOLDS[level]
	if attempts <= thresholds[0]:
		return 3
	elif attempts <= thresholds[1]:
		return 2
	else:
		return 1

