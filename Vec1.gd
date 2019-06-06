extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPEED = 200
const THRESHOLD = 7

var motion = Vector2(0, 0)

var grip_vectors = {}
var grippable_surface = {}
var grip_range = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
	
	calculate_grippable_surfaces()
	motion = move_and_slide(motion)
	
	if Input.is_action_just_pressed("reset_rotation"):
		reset_rotation()
	
	update()

func _draw():
	draw_rect(Rect2(0 - get_half_width(), 0 - get_half_height(), get_width(), get_height()), Color(1, 1, 1))
	
	draw_grip_range()

func calculate_grippable_surfaces(pos = position):
	# An array of vectors representing the eight sides
	# of the entity, which will be used to perform
	# eight raycasts.
	# Adding half-dimensions accounts for the dimensions
	# of the entity so grip detection doesn't start from
	# the dead center of entity.
	grip_vectors = {
		"right": Vector2(get_half_width(), 0), # Right
		"left": Vector2(-get_half_width(), 0), # Left
		"down": Vector2(0, get_half_height()), # Down
		"up": Vector2(0, -get_half_height()), # Up
		"down-right": Vector2(get_half_width(), get_half_height()), # Down-Right
		"down-left": Vector2(-get_half_width(), get_half_height()), # Down-Left
		"up-right": Vector2(get_half_width(), -get_half_height()), # Up-Right
		"up-left": Vector2(-get_half_width(), -get_half_height()) # Up-Left
	}
	
	# The world around the entity.
	var space_state = get_world_2d().direct_space_state
	
	var ret = {}
	for key in grip_vectors:
		var grip_vector = grip_vectors[key]
		var range_value = grip_range * grip_vector.normalized()
		var result = space_state.intersect_ray(
			position + grip_vector,
			position + grip_vector + range_value,
			[self]
		)
		var hit = !result.empty()
		ret[key] = { "hit": hit, "grip_vector": grip_vector, "contact": false }
		if hit:
			var distance = result.position.distance_to(position + grip_vector)
			ret[key] = {
				"hit": hit,
				"distance": distance,
				"contact": in_contact_range(distance),
				"raycast": result,
				"grip_vector": grip_vector
			}
	
	grippable_surface = ret

func get_height():
	return $CollisionShape2D.shape.extents.y * 2

func get_half_height():
	return $CollisionShape2D.shape.extents.y

func get_width():
	return $CollisionShape2D.shape.extents.x * 2

func get_half_width():
	return $CollisionShape2D.shape.extents.x

func draw_grip_range():
	if not grip_vectors.empty():
		for surface in grippable_surface.values():
			var grip_vector = surface.grip_vector
			var range_value = grip_range * grip_vector.normalized()
#			if grip_pressed:
#				print("Position: ", position, ", Global Position: ", global_position, ", Grip Vector: ", grip_vector)
#			draw_circle(Vector2(0, 0), 50, Color(1, 1, 1))
			var color = Color(1, 0, 0)
			if surface.contact:
				color = Color(0, 1, 0)
			elif surface.hit:
				color = Color(0, 0, 1)
			draw_line(Vector2(0, 0) + grip_vector, grip_vector + range_value, color, 1)

func in_contact_range(distance):
	return distance <= THRESHOLD

func reset_rotation():
	rotation = 0