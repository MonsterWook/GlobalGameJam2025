extends Sprite2D

@export var speed = 0.25

signal click(mousePos)

var speechSprite
var thoughtSprite
var background : AnimatedSprite2D
var cursorSprite = load("res://assets/hoverCursor.png")
var path: PathFollow2D

var enter = false
var leave = false

var speechBubble1
var speechBubble2
var speechBubble3
var lockedThoughtBubble

var exitSpeechBubble1
var exitSpeechBubble2
var exitSpeechBubble3

var NPCs = {
	0 : "OfficeGuy",
	1 : "Hustler",
	2 : "Rat"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	speechSprite = $"Speech"
	thoughtSprite = $"Thought"
	background = $"../../../../Background"
	path = $".."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawnCustomer"):
		spawnCustomer()

	if enter:
		if path.progress_ratio < 1:
			path.progress_ratio += 0.25 * delta
		else:
			enter = false
	
	if leave:
		if path.progress_ratio > 0:
			path.progress_ratio -= 0.25 * delta
		else:
			leave = false
			hide()
	
	if Input.is_action_just_pressed("LeftClick"):
		click.emit()

func spawnCustomer() -> void:
	switchNPC()
	show()
	background.play("opened")
	$"../../../../Background/Door".start()
	entranceDialogue(0)
	enter = true

func entranceDialogue(dialogueNumber):
	match(dialogueNumber):
		0:
			speechSprite.set_texture(load(speechBubble1))
			await get_tree().create_timer(2).timeout
			entranceDialogue(1)
		1:
			speechSprite.set_texture(load(speechBubble2))
			await get_tree().create_timer(2).timeout
			entranceDialogue(2)
		2:
			speechSprite.set_texture(load(speechBubble3))
			await get_tree().create_timer(2).timeout
			entranceDialogue(3)
		3:
			speechSprite.set_texture(null)
			thoughtSprite.set_texture(load(lockedThoughtBubble))

func exitDialogue(dialogueNumber):
	match(dialogueNumber):
		0:
			speechSprite.set_texture(load(exitSpeechBubble1))
			await get_tree().create_timer(4).timeout
			exitDialogue(1)
		1:
			speechSprite.position = Vector2(270, 133)
			speechSprite.set_texture(load(exitSpeechBubble2))
			await get_tree().create_timer(2).timeout
			exitDialogue(2)
		2:
			speechSprite.position = Vector2(99.629, -154.319)
			speechSprite.set_texture(load(exitSpeechBubble3))
			leave = true

func switchNPC():
	var NPC = NPCs.get(randi() % NPCs.size())
	
	"""FOR NOW"""
	NPC = "OfficeGuy"
	
	match(NPC):
		"OfficeGuy":
			speechBubble1 = "res://assets/OfficeGuy/testSpeachBubble.png"
			speechBubble2 = "res://assets/OfficeGuy/testSpeachBubble2.png"
			speechBubble3 = "res://assets/OfficeGuy/testSpeachBubble3.png"
			lockedThoughtBubble = "res://assets/OfficeGuy/lockedThoughtBubble.png"
			
			exitSpeechBubble1 = "res://assets/OfficeGuy/officeGuyLeavingSpeechBubble1.png"
			exitSpeechBubble2 = "res://assets/OfficeGuy/officeGuyLeavingSpeechBubble2.png"
			exitSpeechBubble3 = "res://assets/OfficeGuy/officeGuyLeavingSpeechBubble3.png"

func _fucking_leave() -> void:
	exitDialogue(0)

func _close_door() -> void:
	background.play("closed")
