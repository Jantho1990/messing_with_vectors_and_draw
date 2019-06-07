extends Node2D

const THRESHOLD = 3

var grip_vectors = {}
var grippable_surface = {}
var grip_range = 15

var width = 1 # start at 1 to prevent division by 0
var height = 1 # start at 1 to prevent division by 0

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		breakpoint
	calculate_grippable_surfaces()
	update()

func _draw():
	draw_grip_range()

func set_dimensions(width, height):
	self.width = width
	self.height = height

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

func in_contact_range(distance):
	return distance <= THRESHOLD

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

func get_height():
	return height

func get_half_height():
	return height / 2

func get_width():
	return width

func get_half_width():
	return width / 2