## Godot 2D移动

### 一、基本概念

Expression：position += direction * speed * delta

表达式：位置 += 方向 * 速度 * 每帧间隔时间

这里 方向 * 速度 其实就是 向量

这个＋= 就是对位置进行自增，每帧加上后面计算结果值

1、位置 position

首先说一下位置，要理解它我们先从下图看

Godot中图形坐标轴 左上角顶点默认为(0,0)

所以：

Y轴方向 向上移动为负，向下移动为正

X轴方向 向左移动为负，向右移动为正

表达式中位置 代表的是下一帧该节点出现的坐标位置。

![image-20200325004915404.png](https://github.com/oldjell/Godot_Node/blob/master/2D_Move/image-20200325004915404.png)

2、方向 direction

要让节点移动，首先我们要明确的就是方向。

以键盘输入为例，通过Input类的is_action_pressed()方法判断键盘输入：

```python
var _direction : Vector2 = Vector2(0,0)

func _my_Direction ():
	if Input.is_action_pressed("ui_left"):
		_direction.x += -1
	if Input.is_action_pressed("ui_right"):
		_direction.x += 1
	if Input.is_action_pressed("ui_up"):
		_direction.y += -1
	if Input.is_action_pressed("ui_down"):
		_direction.y += 1
	_direction = _direction.normalized()
```

注意最后的normalized()向量归一化，它会是的物体斜线移动也保持一致的距离

如下图所示，如果不归一化斜着右下距离名字大于(1,0)或者(0,1)

![image-20200323052636995](https://github.com/oldjell/Godot_Node/blob/master/2D_Move/image-20200323052636995.png)

关于func _input(event): 写在这里函数里面处理输入，不能当按键按住时不起作用，只起按一次的作用。比如你写在_process里面然后按住左键它会连续向左，而input由于没有每帧处理就只有一次。

2、速度 speed 

速度就是每帧移动的像素，根据你的需求设置。

var speed = 300

3、delta

delta参数包含自从上一次调用_process()以来以秒为单位的时间，类型是浮点数。

每帧运行间隔时间，它使得你的游戏在不同的配置电脑下保持统一性。

比如有的电脑支持1分钟60帧，有的电脑就只能支持1分钟30帧，那不是60帧比30帧多跑了很多距离。所以就需要引入delta参数平衡。

我们知道需要位置其实就是每帧运行刷新屏幕，让人觉得动起来了。

在godot里使用 _process(delta）或 _physics_process(delta) 来刷新

_physics_process(delta) 是2D物理引擎

### 二、Demo 1 基本的上下左右移动

```python
extends Node2D

var _direction:Vector2 = Vector2(0,0) 
var _speed:int = 300

func _process(delta:float) -> void:
	_my_Direction() #每帧监测方向输入
	_move(delta)  #每帧移动

func _my_Direction():
	if Input.is_action_pressed("ui_left"):
		_direction.x += -1
	if Input.is_action_pressed("ui_right"):
		_direction.x += 1
	if Input.is_action_pressed("ui_up"):
		_direction.y += -1
	if Input.is_action_pressed("ui_down"):
		_direction.y += 1
	_direction = _direction.normalized()

func _move(delta:float):
	position += _direction * _speed * delta
    #因为_direction不是局部变量，每帧刷新后要把方向重置为0，否则会一直移动。
	_direction = Vector2.ZERO

```

### 三、Demo2 增加角色转向

方法1：通过Sprite.flip_h翻转。

```python
extends Node2D

onready var _sprite:Sprite = $Sprite # 指定变量类型 可以是程序运行更快

var _direction:Vector2 = Vector2(0,0) 
var _speed:int = 300
var _sprite_direction:bool = false

func _process(delta:float) -> void: # 指定函数返回类型 可以是程序运行更快
	_my_Direction() #每帧监测方向输入
	_move(delta) #每帧移动

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
	

	# Sprite 方向的判断
	if _direction.x < 0:
		_sprite_direction = true
	elif _direction.x > 0:
		_sprite_direction = false
	_sprite.flip_h = _sprite_direction

func _move(delta:float):
	position += _direction * _speed * delta
	_direction = Vector2.ZERO #因为_direction不是局部变量，每帧刷新后要把方向重置为0，否则会一直移动。
```

方法2：通过Node2D.scale翻转。

方法3：还可以通过AnimatedSprite.flip_h翻转，这里没有加动画可以自行试验。

### 四、Demo3 限制在玩家的移动方位在窗口内

1、定义一个字典存移动范围

```python
var _boundary:Dictionary = {minX = 0, minY = 0, maxX = 0, maxY = 0} # 移动范围
```

2、获取屏幕大小、玩家图像大小、图形缩放值

```python
	var screeSize = self.get_viewport().get_visible_rect().size

	var rect = _sprite.get_rect()

	var scale = _sprite.scale
```

3、计算范围值

```python
_boundary.minX = (rect.size.x * scale.x)/2
_boundary.minY = (rect.size.y * scale.y)/2
_boundary.maxX = screeSize.x - (rect.size.x * scale.x)/2
_boundary.maxY = screeSize.y - (rect.size.y * scale.y)/2
```
这里要注意获取的是rect.size.x、rect.size.y 以及 scale.x 及 scale.y 进行运算 

4、创建检测边界函数

```python
func _check_boundary():
	self.position.x = clamp(self.position.x, _boundary.minX, _boundary.maxX)
	self.position.y = clamp(self.position.y, _boundary.minY, _boundary.maxY)
```

5、添加到每帧检测

```python
func _process(delta:float) -> void: 
	_my_Direction() #每帧监测方向输入
	_move(delta) #每帧移动
	_check_boundary() #每帧检测位置范围
```

五、Demo4 移动加速

```Python
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
```

