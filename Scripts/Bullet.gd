extends KinematicBody2D

var MOTION_SPEED = 2000
var dropped = false
var bulletType = "Normal"	# Bounce
var bounces = 0
var canKillPlayer = false
var kills = 0
var player

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_tree().root.get_node("Level/Player")

func _process(delta):
	var movedir = Vector2(1,0).rotated(rotation)
	var motion = movedir.normalized() * MOTION_SPEED
	var collision = move_and_collide(motion*delta)
	
	if collision:
		if collision.collider.is_in_group("Enemy"):
			collision.collider.onHit()
			kills += 1
		elif collision.collider.is_in_group("Player"):
			if canKillPlayer:
				collision.collider.playerHit()
		elif collision.collider.is_in_group("Breakable"):
			collision.collider.onHit()	# Pierces boxes
		elif collision.collider.has_method("onHit"):
			collision.collider.onHit()
			dropped = true
		else:
			if bulletType == "Bounce":
				bounces += 1
				if bounces > 3:
					dropped = true
					canKillPlayer = false
				else:
					var n = collision.normal
					movedir = movedir.bounce(n)
					rotation = movedir.angle()
					move_and_slide(movedir)
					if !canKillPlayer:
						collision_mask = collision_mask | 2	# Adds player collision
						canKillPlayer = true
					
			else:
				dropped = true
				canKillPlayer = false
		if dropped:
			if kills > 1:
				BGMSFX.db = 0
			if kills == 2:
				BGMSFX.play("res://Audio/EvenLouderDoublekill.wav")
				player.killText("Double Kill!", "multikill")
			if kills == 3:
				BGMSFX.play("res://Audio/EvenLouderTriplekill.wav")
				player.killText("TRIPLE KILL!", "multikill")
			if kills == 4:
				BGMSFX.play("res://Audio/EvenLouderQuadrakill.wav")
				player.killText("QUADRAKILL!", "multikill")
			if kills == 5:
				BGMSFX.play("res://Audio/EvenLouderPentakill.wav")
				player.killText("PENTAKILL!!!", "multikill")
			if kills >= 6:
				BGMSFX.play("res://Audio/EvenLouderMultikill.wav")
				player.killText("MULTIKILL!!!!!", "multikill")
			MOTION_SPEED = 0
			collision_mask = collision_mask | 2	# Adds player collision
			collision_mask -= 4	# Removes collision with enemy 