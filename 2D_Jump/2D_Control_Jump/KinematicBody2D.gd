extends KinematicBody2D

const UNIT = 32 #定义标准单位
const FLOOR_NORMAL = Vector2(0, -1) #定义地面法线方向

var MaxHeight = 4.25 * UNIT #定义最大高度
var MaxWidth = 5.25 * UNIT  #定义最大宽度
var Time = 1.0 #定义跳跃总时间
var velocity = Vector2.ZERO # 定义速度向量
var moveSpeed = 0.0 #定义最大横向速度
var JumpSpeed = 0.0 #定义最大竖向速度
var gravity = 0.0 #定义重力加速度

func _ready():
	gravity = 2 * MaxHeight / (Time/2) * (Time/2)
	moveSpeed = MaxWidth / Time
	JumpSpeed = sqrt(2 * gravity * MaxHeight)
	
func _process(delta):
	# 垂直速度不断地受重力的影响，注意需要乘上dalta。
	# 还记得delta么，每帧间隔时间，乘上它会变成按秒计算，而我们的重力按秒计算的
	velocity.y += gravity * delta
	
	# 水平移动控制
	# 说一下这个写法 Input.is_action_pressed('ui_right')返回值是ture或者false
	# int(Input.is_action_pressed('ui_right'))返回值1或0
	# - int(Input.is_action_pressed('ui_left')) 返回值是-1或者0
	# 向右和向左同时只能存在一个，所以hDir返回值同时间只有一个，这就可以获得正确的方向
	var hDir = int(Input.is_action_pressed('ui_right')) - int(Input.is_action_pressed('ui_left'))
	#求X方向的速度向量
	velocity.x = hDir * moveSpeed
	#移动，对velocity重新赋值，抵消垂直速度不断地受重力的影响。之前解释过了。
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
	# 只有在地面上的时候才能跳跃
	if is_on_floor() && Input.is_action_pressed("ui_select"):
		velocity.y = -JumpSpeed #注意这里Y轴向下为正，所以要向上跳为负的


