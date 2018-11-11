extends KinematicBody2D

var MOTION_SPEED = 2000
var dropped = false
var bulletType = "Normal"	# Bounce
var bounces = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	pass

func _process(delta):
	var movedir = Vector2(1,0).rotated(rotation)
	var motion = movedir.normalized() * MOTION_SPEED
	var collision = move_and_collide(motion*delta)
	
	if collision:
		if collision.collider.is_in_group("Enemy"):
			collision.collider.queue_free()
			#pass#TODO create dropped bullet
		elif collision.collider.is_in_group("Player"):
			pass
		elif collision.collider.is_in_group("Breakable"):
			collision.collider.queue_free()
		elif collision.collider.has_method("onHit"):
			collision.collider.onHit()
			dropped = true
		else:
			if bulletType == "Bounce":
				bounces += 1
				if bounces > 3:
					dropped = true
				else:
					var n = collision.normal
					movedir = movedir.bounce(n)
					rotation = movedir.angle()
					move_and_slide(movedir)
			else:
				dropped = true
			#queue_free()
		if dropped:
			MOTION_SPEED = 0
			collision_mask += 2	# Adds player collision
			collision_mask -= 4	# Removes collision with enemy 