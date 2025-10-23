extends TextureButton

const HOVER_SCALE: Vector2 = Vector2(1.1,1.1)
const DEFAULT_SCALE: Vector2 = Vector2(1.0,1.0)

# Color modulation for different states
const COLOR_LOCKED: Color = Color(0.5, 0.5, 0.5, 1.0)  # Gray
const COLOR_AVAILABLE: Color = Color(1.0, 1.0, 0.8, 1.0)  # Light yellow
const COLOR_ONE_STAR: Color = Color(1.0, 0.85, 0.6, 1.0)  # Bronze
const COLOR_TWO_STARS: Color = Color(0.85, 0.85, 0.95, 1.0)  # Silver
const COLOR_THREE_STARS: Color = Color(1.0, 0.95, 0.4, 1.0)  # Gold

@export var level_number: int =1
@onready var level_label = $MC/VB/LevelLabel
@onready var score_label = $MC/VB/ScoreLabel

var _level_scene: PackedScene
var _is_locked: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	level_label.text = str(level_number)
	update_score_display()
	_level_scene = load("res://level/level%s.tscn" % level_number)


func update_score_display() -> void:
	# Check if level is locked (previous level not completed)
	if level_number > 1:
		var previous_completed = ScoreManager.is_level_completed(level_number - 1)
		_is_locked = !previous_completed
	else:
		_is_locked = false  # Level 1 is always unlocked

	var stars = ScoreManager.get_stars_for_level(level_number)

	# Display based on lock status
	if _is_locked:
		score_label.text = "🔒\nVERROUILLÉ"
		self_modulate = COLOR_LOCKED
		disabled = true
	else:
		# Display stars only (no attempt count)
		var star_text = ""
		for i in range(stars):
			star_text += "⭐"
		# Add empty stars for remaining slots
		for i in range(3 - stars):
			star_text += "☆"

		score_label.text = star_text

		# Apply color based on stars
		if stars == 0:
			self_modulate = COLOR_AVAILABLE
		elif stars == 1:
			self_modulate = COLOR_ONE_STAR
		elif stars == 2:
			self_modulate = COLOR_TWO_STARS
		else:  # 3 stars
			self_modulate = COLOR_THREE_STARS

		disabled = false


func _on_pressed():
	if !_is_locked:
		ScoreManager.level_selected(level_number)
		get_tree().change_scene_to_packed(_level_scene)


func _on_mouse_entered():
	if !_is_locked:
		scale = HOVER_SCALE


func _on_mouse_exited():
	if !_is_locked:
		scale = DEFAULT_SCALE
