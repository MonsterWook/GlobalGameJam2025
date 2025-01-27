extends Control

signal FUCKING_LEAVE

@onready var camera: Camera2D = $"../../../../../../Camera2D"

var camZoomSpeed = Vector2(5, 5)
var sceneChange = false
var sceneChange2 = false
var canClick = false
var Offset = Vector2(60, 60)
var oldCamPos
var currentNPC

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
		if camera.zoom < Vector2(9, 9):
			camera.zoom += delta * camZoomSpeed
		else:
			$"../../../../../..".visible = false
			
			get_tree().root.add_child(minigameScene)
			get_tree().root.get_node(nodeWithSignalPath).changeSceneWin.connect(_on_minigame_complete_win)
			get_tree().root.get_node(nodeWithSignalPath).changeSceneLose.connect(_on_minigame_complete_lose)
			sceneChange = false
			camera.position = oldCamPos
			sceneChange2 = true

	if sceneChange2:
		if camera.zoom > Vector2(1.2, 1.2):
			camera.zoom -= delta * camZoomSpeed
		else:
			sceneChange2 = false
			camera.zoom = Vector2(1, 1)

func _on_ready_for_NPC() -> void:
	$".".mouse_entered.connect(_on_mouse_entered)
	$".".mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	canClick = true
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_mouse_exited() -> void:
	canClick = false
	mouse_default_cursor_shape = Control.CURSOR_ARROW

func _on_minigame_complete_win() -> void:
	get_tree().root.get_node(sceneNode).queue_free()
	$"../../../../../..".visible = true
	sceneChange2 = true
	$".".mouse_entered.disconnect(_on_mouse_entered)
	$".".mouse_exited.disconnect(_on_mouse_exited)
	FUCKING_LEAVE.emit(true)
	camera.zoom = Vector2(10, 10)

func _on_minigame_complete_lose() -> void:
	get_tree().root.get_node(sceneNode).queue_free()
	$"../../../../../..".visible = true
	sceneChange2 = true
	$".".mouse_entered.disconnect(_on_mouse_entered)
	$".".mouse_exited.disconnect(_on_mouse_exited)
	FUCKING_LEAVE.emit(false)
	camera.zoom = Vector2(10, 10)

func _on_click(NPC) -> void:
	if (canClick):
		sceneChange = true
		currentNPC = NPC
		switchMinigame()
		oldCamPos = camera.position
		camera.global_position = global_position + Offset

func switchMinigame():
	
	match(currentNPC):
		"OfficeGuy":
			minigameScene = load("res://minigames/typingMinigame/typingMinigame.tscn").instantiate()
			nodeWithSignalPath = "typingMinigame/text"
			sceneNode = "typingMinigame"
		
		"Hustler":
			minigameScene = load("res://minigames/cupMinigame/cupMinigame.tscn").instantiate()
			nodeWithSignalPath = "cupMinigame"
			sceneNode = "cupMinigame"
			
		"Climber":
			minigameScene = load("res://minigames/climberMinigame/climberMinigame.tscn").instantiate()
			nodeWithSignalPath = "climberMinigame"
			sceneNode = "climberMinigame"
		
		"Rat":
			minigameScene = load("res://minigames/ratMinigame/ratMinigame.tscn").instantiate()
			nodeWithSignalPath = "ratMinigame"
			sceneNode = "ratMinigame"
