extends Node2D

onready var _sprite:Sprite = $Sprite

var _direction:Vector2 = Vector2(0,0)  
var _speed:int = 300 
#var _sprite_direction:bool = false #Sprite方向
var _Node2D_flip:int = 1 #Node2D方向
var _boundary:Dictionary = {minX = 0, minY = 0, maxX = 0, maxY = 0} # 移动范围

func _process(delta:float) -> void: 
	_my_Direction() #每帧监测方向输入
	_move(delta) #每帧移动
	_check_boundary() #每帧检测位置范围

func _my_Direction() :
	if Input.is_action_pressed("ui_left"):
		_direction.x += -1
	if Input.is_action_pressed("ui_right"):
		_direction.x += 1
	if Input.is_action_pressed("ui_up"):
		_direction.y += -1
	if Input.is_action_pressed("ui_down"):
		_direction.y += 1
	_direction = _direction.normalized()
		
#	# Sprite 方向的判断，翻转方法1，通过Sprite.flip_h
#	if _direction.x < 0:
#		_sprite_direction = true
#	elif _direction.x > 0:
#		_sprite_direction = false
#	_sprite.flip_h = _sprite_direction
	
	# Node2D 方向的判断，翻转方法2，通过Node2D.scale
	if _direction.x < 0:
		_Node2D_flip = -1
	elif _direction.x > 0:
		_Node2D_flip = 1
	self.scale = Vector2(_Node2D_flip,1)
	
func _move(delta:float):
	position += _direction * _speed * delta
	if position == position: #位置没有发生变化，就重置方向
		_direction = Vector2.ZERO #因为_direction不是局部变量，每帧刷新后要把方向重置为0，否则会一直移动。
		
	if Input.is_action_just_pressed("ui_select"):
		_speed = _speed * 3
		$Particles2D.visible = true
	if Input.is_action_just_released("ui_select"):
		_speed = 300
		$Particles2D.visible = false

func _check_boundary():
	var screeSize = self.get_viewport().get_visible_rect().size
	var rect = _sprite.get_rect()
	var scale = _sprite.scale
	# 设置玩家能移动的上下左右最大范围
	_boundary.minX = (rect.size.x * scale.x)/2
	_boundary.minY = (rect.size.y * scale.y)/2
	_boundary.maxX = screeSize.x - (rect.size.x * scale.x)/2
	_boundary.maxY = screeSize.y - (rect.size.y * scale.y)/2
	self.position.x = clamp(self.position.x, _boundary.minX, _boundary.maxX)
	self.position.y = clamp(self.position.y, _boundary.minY, _boundary.maxY)
