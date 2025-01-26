extends Control

signal FUCKING_LEAVE

@onready var camera: Camera2D = $"../../../../../../Camera2D"

var camZoomSpeed = Vector2(5, 5)
var sceneChange = false
var sceneChange2 = false
var canClick = false
var Offset = Vector2(40, 30)
var oldCamPos

var minigameScene = preload("res://minigames/typingMinigame/typingMinigame.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sceneChange:
		if camera.zoom < Vector2(10, 10):
			camera.zoom += delta * camZoomSpeed
		else:
			#get_tree().root.add_child(minigameScene)
			#get_tree().change_scene_to_file("res://minigames/typingMinigame/typingMinigame.tscn")
			$"../../../../../..".visible = false
			get_tree().root.add_child(minigameScene)
			get_tree().root.get_node("typingMinigame/text").changeScene.connect(_on_minigame_complete)
			sceneChange = false
			camera.global_position = oldCamPos
			sceneChange2 = true

	if sceneChange2:
		if camera.zoom > Vector2(1, 1):
			camera.zoom -= delta * camZoomSpeed
		else:
			sceneChange2 = false


func _on_mouse_entered() -> void:
	canClick = true
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_mouse_exited() -> void:
	canClick = false
	mouse_default_cursor_shape = Control.CURSOR_ARROW

func _on_minigame_complete() -> void:
	get_tree().root.get_node("typingMinigame").queue_free()
	$"../../../../../..".visible = true
	camera.zoom = Vector2(10, 10)
	sceneChange2 = true
	FUCKING_LEAVE.emit()

func _on_click() -> void:
	if (canClick):
		sceneChange = true
		oldCamPos = camera.global_position
		camera.global_position = global_position + Offset
