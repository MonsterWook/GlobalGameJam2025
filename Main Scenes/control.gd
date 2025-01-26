extends Control

signal FUCKING_LEAVE

@onready var camera: Camera2D = $"../../../../../../Camera2D"

var camZoomSpeed = Vector2(5, 5)
var sceneChange = false
var sceneChange2 = false
var canClick = false
var Offset = Vector2(40, 30)
var oldCamPos

var nodeWithSignalPath
var sceneNode
var minigameScene

var minigames = {
	0 : "Typing",
	1 : "Cup",
	2 : "Platformer",
	3 : "Maze"
}

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
			get_tree().root.get_node(nodeWithSignalPath).changeScene.connect(_on_minigame_complete)
			sceneChange = false
			camera.position = oldCamPos
			sceneChange2 = true

	if sceneChange2:
		if camera.zoom > Vector2(1.2, 1.2):
			camera.zoom -= delta * camZoomSpeed
		else:
			sceneChange2 = false
			print(camera.zoom)
			camera.zoom = Vector2(1, 1)

func _on_mouse_entered() -> void:
	canClick = true
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_mouse_exited() -> void:
	canClick = false
	mouse_default_cursor_shape = Control.CURSOR_ARROW

func _on_minigame_complete() -> void:
	get_tree().root.get_node(sceneNode).queue_free()
	$"../../../../../..".visible = true
	camera.zoom = Vector2(10, 10)
	sceneChange2 = true
	FUCKING_LEAVE.emit()

func _on_click() -> void:
	if (canClick):
		sceneChange = true
		switchMinigame()
		oldCamPos = camera.position
		camera.global_position = global_position + Offset

func switchMinigame():
	var minigame = minigames.get(randi() % minigames.size())
	
	"""FOR NOW"""
	var inti = randi()
	inti %= 2
	minigame = minigames.get(inti)
	
	match(minigame):
		"Typing":
			minigameScene = load("res://minigames/typingMinigame/typingMinigame.tscn").instantiate()
			nodeWithSignalPath = "typingMinigame/text"
			sceneNode = "typingMinigame"
		
		"Cup":
			minigameScene = load("res://minigames/cupMinigame/cupMinigame.tscn").instantiate()
			nodeWithSignalPath = "cupMinigame"
			sceneNode = "cupMinigame"
