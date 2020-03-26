## Godot 2D跳跃

### 一、基本跳跃实例

2D跳跃，就是给他一个向上的向量，然后每帧有个向下的向量(重力)让他递减。

实现的方法很简单

```python
extends KinematicBody2D

var moveSpeed = 200     # 移动速度
var jumpSpeed = -500    # 跳跃速度
var motion = Vector2()  # 移动向量
var firstJump = false   #第一次跳跃标志符 

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
            
	motion = move_and_slide(motion,UP)
	#这里对 motion 赋值，使得motion.y每次都被重新刷新。
	#不然motion.y += 9.8 每次都在自增，下一次起跳下落速度会非常快。
	#如果是水平移动 motion.y会被刷新成0
```

这里用到了2个物理物体节点:

1、静态体 StaticBody2D：

 自动碰撞检测，位置固定不变，一般用于固定的墙壁、地面等。

2、动态体 KinematicBody2D：

 参与碰撞检测，无自动响应，完全由代码控制移动，主要用于由代码控制的带物理属性的玩家。

**用到了 动态体 KinematicBody2D 的 move_and_slide()方法：**

```python
Vector2 move_and_slide(linear_velocity: Vector2, up_direction: Vector2 = Vector2( 0, 0 ), stop_on_slope: bool = false, max_slides: int = 4, floor_max_angle: float = 0.785398, infinite_inertia: bool = true)
```

* 它的返回值为：Vector2  表示移动碰撞后的实际速度

* 第一个参数 linear_velocity 为 Vector2 类型，表示速度，不需要乘以 delta，已经自动处理了。

* 第二个参数 up_direction 为 Vector2 类型，表示地面法线方向，默认值 (0, 0）。设定地面法线方向后，可以配合 is_on_floor() 、is_on_wall()、is_on_ceiling()方法来检测玩家是在地面上、墙上还是天花板上。
* 第三个参数 stop_on_slope 能不能在斜坡上滑动，默认为false可以移动。
* 第四个参数 max_slides 停止运动前最大碰撞次数 ，数值过低可能会直接终止运动，默认 4。
* 第五个参数 floor_max_angle 能移动的最大斜坡角度，弧度计，默认值 0.785398 即 45°。
* 第六个参数 infinite_inertia 无限惯性  body将能够推送RigidBody2D节点，但也不会检测到与它们的任何碰撞.如果 false ，它将像StaticBody2D一样与RigidBody2D节点交互。

### 二、如何实现二次跳跃

1、加入第一次跳跃标识符 var firstJump = false

2、修改代码为：

```python
if Input.is_action_just_pressed("ui_select"):
	if is_on_floor() and firstJump == false: #如果在地面，且没有第一次跳跃
		motion.y = jumpSpeed
		firstJump = true
	elif !is_on_floor() and firstJump == true: #如果不在地面，且有第一次跳跃
		motion.y = jumpSpeed * 0.8
		firstJump = false
```
### 三、如果精准的控制跳跃高度

这里宽度、高度度量单位 是像素，说白了就是要位置多少像素。

回到Godot打开捕捉开关，设置吸附里面修改网格大小，比如设置32*32，就可以看到画面被分割成一个一个小网格。

这时候你可以用代码指定一个标准 const UNIT = 32，这个UNIT就是你设置的标准单位，一个UNIT32像素。

* 我要跳4个宽度就是 5*UNIT，但是要留有余量所以可是 5.25 * UNIT

* 同理我要跳3个高度高就是 4 * UNIT，留余就是 4.25  *  UNIT

这里还有一个参数需要你来指定，就是跳跃在空中的总时间，jumpTime，它是包含上升和下落时间。

![image-20200326072402960](C:\Users\MarioJY\Desktop\image-20200326072402960.png)

先列一下我们的已知条件：

最高高度H、最大宽度V、跳跃总时间T。

要求解 ：

1、重力gravity 

重力加速度可以根据距离公式计算，所以 g = 2H / t * t , t = T/2

2、速度velocity

速度分为 横向 velocity.x 和 竖向 velocity.y

横向最大速度 velocity.x 定义为 移动速度 moveMaxSpeed ，所以 moveMaxSpeed = 最大宽度V / 时间T

竖向最大速度velocity.y 定义为 跳跃速度 jumpMaxSpeed：

vmax = gt ， t = sqrt（2h/g） ， vmax = sqrt（2gh），jumpMaxSpeed = sqrt（2 * gravity * MaxHeight ）

```python
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
	# 垂直速度不断地受重力的影响，需要乘上dalta
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
	
func _input(event):
	# 只有在地面上的时候才能跳跃
	if is_on_floor() && event.is_action_pressed("ui_select"):
		velocity.y = -JumpSpeed #注意这里Y轴向下为正，所以要向上跳为负的

```









