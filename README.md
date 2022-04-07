# GT7白嫖脚本

### 这是什么？

- 使用图像识别白嫖泛美第一场，暂时测试效率为每小时500K左右，理论上24小时可以产出1.2M
- 不会被每日任务打断


### 怎么用？

- 文件：需要整体放入按键精灵文件夹中（路径可以有中文），并修改脚本第三行的QMScriptFolder为你的按键精灵根目录（不用相对目录的原因是按键精灵有bug，[点我了解bug详情](https://zimaoxy.com/q/post/findpic/)）
- F9键：运行脚本（请在世界赛道页面启动本脚本，随便光标在哪）
- F12键：停止脚本
- 控制器设置：十字左右键方向，上键油门
- 车辆选择：道奇SRT S，改装赛车软胎

```
  暂时只支持将PS Remote Play设置为1920x1039大小（即包含下方Windows任务栏的窗口模式）
  并且需要将PS Remote Play窗口的左上角对齐屏幕的左上角（坐标：0,0）
```


### 会有什么错误的打开方式？

- 网络延迟时可能会有图像识别不到的情况，脚本会自动重试并在网络恢复后继续执行
- 偶尔可能会有卡住无法继续执行的情况，比如进入了第二场或者选择赛道时进错了赛道
- 比赛中的图像识别还没想到很好的方式，为了防止中途突然断油所以增加了一些很傻的保护机制，这可能导致比赛结束后脚本没有进入结算环节，耐心等待几秒即可


### 遇到错误该怎么办？

- 停止脚本并手动退出比赛至世界赛道页面，重新运行脚本
- 通过任何方式联系我并提交遇到的问题（最好能使用调试模式来运行脚本，这样会有一堆包含我碎碎念的log...）


### 不好用，能不能改进下？

- 支持任意PS Remote Play窗口大小和窗口位置
- 优化跑法，提高白嫖效率
- 降低按键间隔，提高白嫖效率
- 提升图像识别准确率，提高白嫖效率
- 添加更多脚本选择
