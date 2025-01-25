extends Control

var minigameScene = preload("res://minigames/typingMinigame/typingMinigame.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_mouse_exited() -> void:
	mouse_default_cursor_shape = Control.CURSOR_ARROW


func _on_at_ease_click(mousePos) -> void:
	mousePos -= global_position
	if (0 <= mousePos.x && mousePos.x <= 75) && (0 <= mousePos.y && mousePos.y <= 65):
		get_tree().change_scene_to_file("res://minigames/typingMinigame/typingMinigame.tscn")
		#get_tree().root.add_child(minigameScene)
