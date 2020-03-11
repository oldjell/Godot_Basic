# Paritcles2D  粒子节点

上节Godot3.2_Node_RayCast2D(2D射线)我们用到了Partcles2D粒子

下面我们就来说一下Godot3.2_Node_Pariticles2D(2D粒子)

常见的粒子特效火焰、爆炸、烟、水流、火花、云、雾等等

比如你玩LOL就可以看到很多粒子特效

![](http://03.imgmini.eastday.com/mobile/20180308/20180308002859_b5919073cf56b73c575d03e3734a72b9_18.gif)

打开Godot Ctrl+A 添加Partcles2D

如果需要Godot3.2 汉化汉化版 可以加QQ群 673791862下载，这里 https://www.bilibili.com/video/av94395738 宝儿姐也介绍过了，急需更多的Godoter加入汉化大家庭。

看右边属性面板，从上往下

### 一、基础属性

Emitting 发射 启用：就是开启粒子效果

Amount 数量：就是一个发射周期发射的粒子数

### 二、 时间面板

1、Lifetime 生命：就是每个粒子存在的时间

2、One Shot 发射一次：上面的发射是一直重复自动发射，如果需要代码控制就在这里勾选发射一次。

3、Preprocess 预处理：预热提前发射粒子

4、Speed Scale 速度缩放：整体效果，影响粒子材质中的初始速度 -> 速度参数，如果为0就暂停粒子

5、Explosiveness 爆炸性： 粒子从中间往四周扩散，爆炸特效必备

6、Randomness 随机性：粒子产生的随机性，值为1就是完全随机

7、Fixed Fps 固定FPS：控制粒子渲染的帧数率

8、Fract Delta 分数增量：平滑粒子显示效果

### 三、处理材质 -- 材质 面板

粒子节点都需要新建材质才能产生效果

这里说一下ParticlesMaterial粒子材质的参数作用

1、Time 时间 -- 生命随机性 粒子生命周期随机性

2、Trall 用于制作粒子轨迹

​	2.1、Divisor 将发射的数量/Divisor 剩余的粒子将用为轨迹

​	2.2 Size Modifier  新建curvetexture 曲线 控制轨迹粒子大小曲线变化

​	2.3 ColorModifer 可以新建渐变 控制轨迹粒子颜色变化

3、 Emission Shape 发射形状 有Point点、Sphere球、Box方形、Ponits多点、directedpoint定向点 这些是控制粒子发射范围的形状

4、Flags 标记 对齐Y 旋转Y 禁用Z  控制粒子Y、Z轴的关系

5、Direction 方向 XYZ 控制粒子的方向，这里要把重力关掉

​	5.1 Spread 传播 最大值为 180 度乘以 2 倍，即全范围发射： -180°~180°  作用于X/Z Y/Z平面

​	5.2 Flatness 平整度  值为1的话会把粒子限制在X/Z平面

6、Gravity 重力 设置x、y、z方向重力 

7、Initial Velocity 初始速度

​	7.1 Velocity 速度 设置每个粒子初始速度

​	7.2 Velocity Rando 速度随机

8、 Angular Velocity 角速度

​	8.1 Velocity 速度 设置粒子的旋转速度

​	8.2 Velocity  Rando 速度随机率

​	8.3 Velocity  Curve 速度曲线

9、Orbit Velocity 轨道速度 理解成自转就OK了 

10、Linear Velocity 线性加速度  按字面意思理解

11、 Radial Accel 径向加速度

12、Tangential Accel 切向加速度

上面这个请看图，径向是指在这个园上任一点通过园心的直径方向上，
切向是指园周任一些点的切线方向。
![](https://iknow-pic.cdn.bcebos.com/d1a20cf431adcbef2d65408aa1af2edda2cc9fec?x-bce-process=image/resize,m_lfit,w_600,h_800,limit_1)

13、Damping 阻尼

​	13.1 Damping  阻尼 粒子速度下降的速率

​	13.2 Damping Ran 随机衰减

​	13.2 Damping Curv 衰减曲线

14、Angle 角度

​	14.1 Angle  角度：粒子初始旋转角度

​	14.2 Angle  Random 角度随机

​	14.3 Angle  Curve 角度曲线

15、Scale 缩放 

​	15.1 Scale 缩放粒子的大小

​	15.2 Scale Random 缩放随机

​	15.3 Scale Curve 缩放曲线

16、Color 颜色

​	16.1 Color  颜色 设置粒子颜色

​	16.2 Color  Ramp 颜色渐变

17、 Hue Variation 色调变化 从一种色彩倾向转向为另一种色彩倾向

18、Animation 动画

19、Resource 资源

### 四、补充

绘制里面的局部位置 开启和关闭大家可以测试一下效果 有惊喜



### Demo 粒子火焰效果

1、新建Particiles2D节点

2、设置属性：

发射：启用 / 数量：100

生命：2 / 速度缩放：3 / 

新增 粒子贴图

发射形状Box：x 10 y20 z1 / 方向 y -90 / 重力 0 / 速度 50 / 角速度360 / 线性加速度25 / 角度 45 / 缩放 25 曲线0.75 到0.5 / 颜色 白 橙 红 渐变 