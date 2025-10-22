extends TextureButton

const HOVER_SCALE: Vector2 = Vector2(1.1,1.1)
const DEFAULT_SCALE: Vector2 = Vector2(1.0,1.0)

@export var level_number: int =1
@onready var level_label = $MC/VB/LevelLabel
@onready var score_label = $MC/VB/ScoreLabel

var _level_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	level_label.text = str(level_number)
	update_score_display()
	_level_scene = load("res://level/level%s.tscn" % level_number)


func update_score_display() -> void:
	var stars = ScoreManager.get_stars_for_level(level_number)
	var best_score = ScoreManager.get_best_for_level(level_number)

	# Display stars
	var star_text = ""
	for i in range(stars):
		star_text += "⭐"
	# Add empty stars for remaining slots
	for i in range(3 - stars):
		star_text += "☆"

	# Show stars and best score (if level completed)
	if stars > 0:
		score_label.text = star_text + "\n" + str(best_score) + " essais"
	else:
		score_label.text = "Non complété"


func _on_pressed():
	ScoreManager.level_selected(level_number)
	get_tree().change_scene_to_packed(_level_scene)


func _on_mouse_entered():
	scale = HOVER_SCALE


func _on_mouse_exited():
	scale = DEFAULT_SCALE
