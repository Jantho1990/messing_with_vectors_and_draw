extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPEED = 200

var motion = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	queue_free()
#	$GripDetection.set_dimensions(get_width(), get_height())

func _physics_process(delta):
	var speed = SPEED
	if Input.is_action_pressed("slow"):
		speed *= 0.1

	if Input.is_action_pressed("ui_left"):
		motion.x = -speed
	elif Input.is_action_pressed("ui_right"):
		motion.x = speed
	else:
		motion.x = 0

	if Input.is_action_pressed("ui_up"):
		motion.y = -speed
	elif Input.is_action_pressed("ui_down"):
		motion.y = speed
	else:
		motion.y = 0

	if Input.is_action_pressed("rotate_left"):
		rotation -= 0.03
	elif Input.is_action_pressed("rotate_right"):
		rotation += 0.03

#	calculate_grippable_surfaces()
	motion = move_and_slide(motion)

	if Input.is_action_just_pressed("reset_rotation"):
		reset_rotation()

	update()

func _draw():
	draw_rect(Rect2(0 - get_half_width(), 0 - get_half_height(), get_width(), get_height()), Color(1, 1, 1))

func calculate_grippable_surfaces(pos = position):
	return $GripDetection.calculate_grippable_surfaces(position)

func get_height():
	return $CollisionShape2D.shape.extents.y * 2

func get_half_height():
	return $CollisionShape2D.shape.extents.y

func get_width():
	return $CollisionShape2D.shape.extents.x * 2

func get_half_width():
	return $CollisionShape2D.shape.extents.x



func reset_rotation():
	rotation = 0