extends Control

@onready var camera: Camera2D = $"../../../Camera2D"

var camZoomSpeed = Vector2(3, 3)
var sceneChange = false
var canClick = false

var minigameScene = preload("res://minigames/typingMinigame/typingMinigame.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sceneChange:
		if camera.zoom <= Vector2(10, 10):
			camera.zoom += delta * camZoomSpeed
		else:
			#get_tree().root.add_child(minigameScene)
			get_tree().change_scene_to_file("res://minigames/typingMinigame/typingMinigame.tscn")


func _on_mouse_entered() -> void:
	canClick = true
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_mouse_exited() -> void:
	canClick = false
	mouse_default_cursor_shape = Control.CURSOR_ARROW


func _on_click() -> void:
	if (canClick):
		sceneChange = true
		var Offset = Vector2(40, 30)
		camera.global_position = global_position + Offset
