extends Node2D

onready var beam = $Beam
onready var end = $End
onready var rayCast = $RayCast2D

const MAX_LENGTH = 2000 

func _physics_process(delta):
	var mouse_position = get_local_mouse_position() #获取鼠标位置
	var max_cast_to = mouse_position.normalized() * MAX_LENGTH #设置射线各方向最大长度
	rayCast.cast_to = max_cast_to
	if rayCast.is_colliding():
		end.global_position = rayCast.get_collision_point()
		var node = rayCast.get_collider()
		print(node.name)
		if node.is_class('Area2D'):
			node.free()
	else:
		end.global_position = rayCast.cast_to
	
	beam.rotation = rayCast.cast_to.angle()
	beam.region_rect.end.x = end.position.length()


