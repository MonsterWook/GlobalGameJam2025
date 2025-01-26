extends AnimatedSprite2D

@export var speed = 0.25

signal click(mousePos)
signal readyForNPC
signal firstBubble

var speechSprite
var thoughtSprite : AnimatedSprite2D
var background : AnimatedSprite2D
var thoughtText : Label
var cursorSprite = load("res://assets/hoverCursor.png")
var path: PathFollow2D
var NPC

var enter = false
var leave = false
var leavingDoor = true

var speechBubble1
var speechBubble2
var speechBubble3
var lockedThoughtBubble

var unlockedThoughtBubble
var exitSpeechBubble1
var exitSpeechBubble2
var exitSpeechBubble3

var NPCs = {
	0 : "OfficeGuy",
	1 : "Hustler",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	speechSprite = $"Speech"
	thoughtSprite = $"Thought"
	background = $"../../../../Background"
	thoughtText = $Thought/Label
	path = $".."
	$"../../../../NPCSpawner".start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if enter:
		if path.progress_ratio < 1:
			path.progress_ratio += 0.25 * delta
		else:
			enter = false
			firstBubble.emit()
	
	if leave:
		if path.progress_ratio > 0:
			if path.progress_ratio < 0.25 && leavingDoor:
				background.play("opened")
				$"../../../../Background/Door".start()
				leavingDoor = false
			path.progress_ratio -= 0.25 * delta
		else:
			leave = false
			leavingDoor = true
			hide()
			$"../../../../NPCSpawner".start()
			readyForNPC.emit()
	
	if Input.is_action_just_pressed("LeftClick"):
		click.emit(NPC)

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
			await firstBubble
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
			thoughtSprite.show()
			thoughtSprite.play("ThoughtBubbleForming")
			await thoughtSprite.animation_finished
			thoughtSprite.play("LockedThoughtBubble")

func exitDialogue(dialogueNumber):
	match(dialogueNumber):
		0:
			thoughtSprite.play("ThoughtBubble")
			thoughtText.text = unlockedThoughtBubble
			await get_tree().create_timer(3).timeout
			exitDialogue(1)
		1:
			thoughtSprite.hide()
			speechSprite.position = Vector2(270, 133)
			speechSprite.set_texture(load(exitSpeechBubble1))
			await get_tree().create_timer(2).timeout
			exitDialogue(2)
		2:
			speechSprite.position = Vector2(99.629, -154.319)
			speechSprite.set_texture(load(exitSpeechBubble2))
			leave = true

func switchNPC():
	var inti = randi() % NPCs.size()
	NPC = NPCs.get(inti)
	
	play(NPC)
	
	match(NPC):
		"OfficeGuy":
			
			speechBubble1 = "res://assets/OfficeGuy/testSpeachBubble.png"
			speechBubble2 = "res://assets/OfficeGuy/testSpeachBubble2.png"
			speechBubble3 = "res://assets/OfficeGuy/testSpeachBubble3.png"
			
			unlockedThoughtBubble = ""
			exitSpeechBubble1 = "res://assets/OfficeGuy/officeGuyLeavingSpeechBubble2.png"
			exitSpeechBubble2 = "res://assets/OfficeGuy/officeGuyLeavingSpeechBubble3.png"
		
		"Hustler":
			speechBubble1 = "res://assets/Hustler/hustlerEnterDialogue1.png"
			speechBubble2 = "res://assets/Hustler/hustlerEnterDialogue2.png"
			speechBubble3 = "res://assets/Hustler/hustlerEnterDialogue3.png"
			
			unlockedThoughtBubble = "I haven't done a card scam in a while"
			exitSpeechBubble1 = "res://assets/Hustler/hustlerExitDialogue1.png"
			exitSpeechBubble2 = "res://assets/Hustler/hustlerExitDialogue2.png"

func _fucking_leave() -> void:
	exitDialogue(0)

func _close_door() -> void:
	background.play("closed")
