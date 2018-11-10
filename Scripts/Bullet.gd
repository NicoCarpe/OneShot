extends KinematicBody2D

var MOTION_SPEED = 500
var dropped = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
	var movedir = Vector2(1,0).rotated(rotation)
	var motion = movedir.normalized() * MOTION_SPEED
	var collision = move_and_collide(motion*delta)
	
	if collision:
		if collision.collider.is_in_group("Enemy"):
			collision.collider.queue_free()
			#pass#TODO create dropped bullet
		elif collision.collider.is_in_group("Player"):
			pass
		else:
			dropped = true
			#queue_free()
		if dropped:
			MOTION_SPEED = 0
			collision_mask += 2
			#collision_mask = Remove collision with enemy 