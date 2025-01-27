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

var exitSpeechBubbleLost1
var exitSpeechBubbleLost2

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
			await get_tree().create_timer(4).timeout
			entranceDialogue(2)
		2:
			speechText.text = speechBubble3
			await get_tree().create_timer(4).timeout
			entranceDialogue(3)
		3:
			speechSprite.hide()
			thoughtSprite.play("ThoughtBubbleForming")
			thoughtSprite.show()
			await thoughtSprite.animation_finished
			thoughtSprite.play("LockedThoughtBubble")

func exitDialogueWon(dialogueNumber):
	match(dialogueNumber):
		0:
			thoughtSprite.play("ThoughtBubble")
			thoughtText.text = unlockedThoughtBubble
			await get_tree().create_timer(4).timeout
			exitDialogueWon(1)
		1:
			thoughtSprite.hide()
			speechSprite.show()
			oldSpeechBubblePos = speechSprite.position
			speechSprite.position = Vector2(60, 40)
			speechText.text = exitSpeechBubble1
			await get_tree().create_timer(4).timeout
			exitDialogueWon(2)
		2:
			speechSprite.position = oldSpeechBubblePos
			speechText.text = exitSpeechBubble2
			leave = true

func exitDialogueLost(dialogueNumber):
	match(dialogueNumber):
		0:
			thoughtSprite.play("LockedThoughtBubbleLost")
			await thoughtSprite.animation_finished
			exitDialogueLost(1)
		1:
			thoughtSprite.hide()
			speechSprite.show()
			oldSpeechBubblePos = speechSprite.position
			speechSprite.position = Vector2(60, 40)
			speechText.text = exitSpeechBubbleLost1
			await get_tree().create_timer(4).timeout
			exitDialogueLost(2)
		2:
			speechSprite.position = oldSpeechBubblePos
			speechText.text = exitSpeechBubbleLost2
			leave = true

func switchNPC():
	var oldNPC = NPC
	var inti = randi() % (NPCs.size() - 1)
	NPC = NPCs.get(inti)
	
	if NPC == oldNPC:
		NPC = NPCs.get(NPCs.size() - 1)
	
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
			speechBubble2 = "I haven't been getting any suckers to fall for my scams lately"
			speechBubble3 = "What should I do doc'?"
			
			unlockedThoughtBubble = "I haven't done a card scam in a while"
			exitSpeechBubble1 = "I heard about this new scam using cards, here let me fill you in"
			exitSpeechBubble2 = "Ooh that's clever, you're the best doc'"
			
			exitSpeechBubbleLost1 = "Maybe you should try your hand at a different career?"
			exitSpeechBubbleLost2 = "Says you! You hack, I knew it was a waste coming here"
			
		"Rat":
			flip_h
			
			speechBubble1 = "Wow, what a fine place you have here"
			speechBubble2 = "Hey fellow human, I am starving"
			speechBubble3 = "You know of a place where a human like me can get some grub?"
			
			unlockedThoughtBubble = "I need cheese. I need cheese. I need cheese. I need cheese."
			exitSpeechBubble1 = "There is a cheese factory just down the road that serves the best cheese"
			exitSpeechBubble2 = "Amazing! ...ahem, I meean cheese is alright. Thank you fellow human"

		"Climber":
			
			speechBubble1 = "Haha, Mt. Everest couldn't be further from here"
			speechBubble2 = "I'm working up to doing my hardest climb yet"
			speechBubble3 = "What should I do in preparation?"
			
			unlockedThoughtBubble = "Ugh, I wish I didn't have to train"
			exitSpeechBubble1 = "Training is for amateurs, just send it. You'll be fine"
			exitSpeechBubble2 = "You know what? You are right, I got this!"
			
			exitSpeechBubbleLost1 = "Work on your endurance, strength, and flexibility. And don't forget to rest right before!"
			exitSpeechBubbleLost2 = "Damn it. Yea I know, I know. What are you, my mom?"

func _fucking_leave(won) -> void:
	if won:
		exitDialogueWon(0)
	else:
		exitDialogueLost(0)

func _close_door() -> void:
	background.play("closed")
