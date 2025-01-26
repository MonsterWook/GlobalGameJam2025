extends AnimatedSprite2D

@export var speed = 0.25

signal click(mousePos)
signal readyForNPC
signal firstBubble

var speechSprite
var thoughtSprite : AnimatedSprite2D
var background : AnimatedSprite2D
var thoughtText : Label
var speechText : Label
var oldSpeechBubblePos
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

var NPCs = {
	0 : "OfficeGuy",
	1 : "Hustler",
	2 : "Rat",
	3 : "Climber"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	speechSprite = $"Speech"
	thoughtSprite = $"Thought"
	background = $"../../../../Background"
	thoughtText = $Thought/Label
	speechText = $Speech/Label
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
			speechSprite.show()
			speechText.text = speechBubble1
			await firstBubble
			entranceDialogue(1)
		1:
			speechText.text = speechBubble2
			await get_tree().create_timer(2).timeout
			entranceDialogue(2)
		2:
			speechText.text = speechBubble3
			await get_tree().create_timer(2).timeout
			entranceDialogue(3)
		3:
			speechSprite.hide()
			thoughtSprite.show()
			thoughtSprite.play("ThoughtBubbleForming")
			await thoughtSprite.animation_finished
			thoughtSprite.play("LockedThoughtBubble")

func exitDialogue(dialogueNumber):
	match(dialogueNumber):
		0:
			thoughtSprite.play("ThoughtBubble")
			thoughtText.text = unlockedThoughtBubble
			await get_tree().create_timer(4).timeout
			exitDialogue(1)
		1:
			thoughtSprite.hide()
			speechSprite.show()
			oldSpeechBubblePos = speechSprite.position
			speechSprite.position = Vector2(40, 40)
			speechText.text = exitSpeechBubble1
			await get_tree().create_timer(3).timeout
			exitDialogue(2)
		2:
			speechSprite.position = oldSpeechBubblePos
			speechText.text = exitSpeechBubble2
			leave = true

func switchNPC():
	var oldNPC = NPC
	var inti = randi() % (NPCs.size() - 1)
	NPC = NPCs.get(inti)
	
	if NPC == oldNPC:
		NPC = NPC.get(NPCs.size() - 1)
	
	if oldNPC == "Rat":
		flip_h
		
	play(NPC)
	
	match(NPC):
		"OfficeGuy":
			
			speechBubble1 = "I heard you are the best clairvoyant around"
			speechBubble2 = "I am so tired of my dead end job"
			speechBubble3 = "Please tell me how to get out of this meaningless life"
			
			unlockedThoughtBubble = "I hope he tells me to buy bitcoin"
			exitSpeechBubble1 = "You should buy some BubbleCoin. I heard it's popping off"
			exitSpeechBubble2 = "Thanks! you are a gentleman and a scholar"
		
		"Hustler":
			speechBubble1 = "Haha, this reminds me of the good ol' days"
			speechBubble2 = "I haven't been getting enough suckers to fall for my scams lately"
			speechBubble3 = "What should I do doc'?"
			
			unlockedThoughtBubble = "I haven't done a card scam in a while"
			exitSpeechBubble1 = "I heard about this new scam using cards, here let me fill you in"
			exitSpeechBubble2 = "Ooh that's clever, you're the best doc'"
			
		"Rat":
			flip_h
			
			speechBubble1 = ""
			speechBubble2 = ""
			speechBubble3 = ""
			
			unlockedThoughtBubble = ""
			exitSpeechBubble1 = ""
			exitSpeechBubble2 = ""

		"Climber":
			
			speechBubble1 = ""
			speechBubble2 = ""
			speechBubble3 = ""
			
			unlockedThoughtBubble = ""
			exitSpeechBubble1 = ""
			exitSpeechBubble2 = ""

func _fucking_leave() -> void:
	exitDialogue(0)

func _close_door() -> void:
	background.play("closed")
