extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPEED = 200

var motion = Vector2(0, 0)

var ray = RayCast2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	ray.position += Vector2(20, 0)
	ray.cast_to = Vector2(50, 0)
	ray.exclude_parent = true
	ray.collide_with_areas = true
	ray.collide_with_bodies = true
	ray.enabled = true
	add_child(ray)
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
	draw_rect(Rect2(0 - get_half_width(), 0 - get_half_height(), get_width(), get_height()), Color(0, 0, 0))
	
	draw_ray()
	

func draw_ray():
	var color = Color(1, 0, 0)
	if ray.is_colliding():
		color = Color(0, 0, 1)
		var coll = ray.get_collider()
#		breakpoint
#		print(ray.get_collider())
	draw_line(ray.position, ray.position + ray.cast_to, color)

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

func ray_is_colliding():
	var collider = ray.get_collider()
	if collider:
		return true
	return false

func reset_rotation():
	rotation = 0