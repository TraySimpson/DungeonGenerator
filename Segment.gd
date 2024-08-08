class_name Segment
extends RefCounted

var size: Vector2i
var position: Vector2i
var weight: int
var connections := []

func get_room_weight() -> int:
	return size.x * size.y
