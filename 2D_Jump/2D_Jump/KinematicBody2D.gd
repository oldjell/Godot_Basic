extends KinematicBody2D

var moveSpeed = 200      # 移动速度
var jumpSpeed = -500     # 跳跃速度
var motion = Vector2()   # 移动向量
var firstJump = false    #第一次跳跃标志符
 
const UP = Vector2(0, -1) #定义一个方向向上的单位向量，用来定义地面法线

func _process(delta):  # 每帧执行一次
	motion.y += 9.8
	if Input.is_action_pressed("ui_right"):
		motion.x = moveSpeed;  

	elif Input.is_action_pressed("ui_left"):
		motion.x = -moveSpeed; 

	else:
		motion.x = 0  

	if Input.is_action_just_pressed("ui_select"):
		if is_on_floor() and firstJump == false:
			motion.y = jumpSpeed
			firstJump = true
		elif !is_on_floor() and firstJump == true:
			motion.y = jumpSpeed * 0.8
			firstJump = false
	motion = move_and_slide(motion,UP)
	#这里对 motion 赋值，使得motion.y每次都被重新刷新。
	#不然motion.y += 9.8 每次都在自增，下一次起跳下落速度会非常快。
	#如果是水平移动 motion.y会被刷新成0
