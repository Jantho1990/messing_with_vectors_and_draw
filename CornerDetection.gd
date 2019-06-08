extends Node2D

enum {
	UP_LEFT_90,
	UP_LEFT_120,
	UP_LEFT_135,
	UP_LEFT_150,
	UP_LEFT_210,
	UP_LEFT_225,
	UP_LEFT_240,
	UP_LEFT_270,
	UP_RIGHT_90,
	UP_RIGHT_120,
	UP_RIGHT_135,
	UP_RIGHT_150,
	UP_RIGHT_210,
	UP_RIGHT_225,
	UP_RIGHT_240,
	UP_RIGHT_270,
	DOWN_LEFT_90,
	DOWN_LEFT_120,
	DOWN_LEFT_135,
	DOWN_LEFT_150,
	DOWN_LEFT_210,
	DOWN_LEFT_225,
	DOWN_LEFT_240,
	DOWN_LEFT_270,
	DOWN_RIGHT_90,
	DOWN_RIGHT_120,
	DOWN_RIGHT_135,
	DOWN_RIGHT_150,
	DOWN_RIGHT_210,
	DOWN_RIGHT_225,
	DOWN_RIGHT_240,
	DOWN_RIGHT_270
}

# Identify what kind of corner we are in.
func detect_corner_type(contacts_and_hits):
	# Match against list of contacts and hits and return appropriate
	# corner string.
	match contacts_and_hits:
		["left", "up", _, "up-right", "up-left", ..]:
			return UP_LEFT_90
		["right", "up", _, "up-right", "up-left", ..]:
			return UP_RIGHT_90
		["left", "down", "down-right", "down-left", ..]:
			return DOWN_LEFT_90
		["right", "down", "down-right", "down-left", ..]:
			return DOWN_RIGHT_90
		_:
			return -1