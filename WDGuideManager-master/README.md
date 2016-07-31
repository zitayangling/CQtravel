# WDGuideManager
##简易的引导页控件,非常容易使用
![](https://github.com/wangda6571819/WDGuideManager/blob/master/1.png)
![](https://github.com/wangda6571819/WDGuideManager/blob/master/2.png)
![](https://github.com/wangda6571819/WDGuideManager/blob/master/3.png)

###非常容易使用只需要 
###在你的工程文件中 写明 

pod 'WDGuideManager', :git => 'https://github.com/wangda6571819/WDGuideManager.git'

###里面有展示的demo  使用前需要 import "WDGuideManager.h"

NSMutableArray *paths = [NSMutableArray new];

[paths addObject:[UIImage imageNamed:@"guide_1"]];

[paths addObject:[UIImage imageNamed:@"guide_2"]];

[paths addObject:[UIImage imageNamed:@"guide_3"]];

[paths addObject:[UIImage imageNamed:@"guide_4"]];

[[WDGuideManager shared] showGuideViewWithImages:paths];

[WDGuideManager shared].delegate = self;

##就能轻松的创建引导页了

###可以书写 delegate 方法 （现版本默认有两个按钮登录和注册）

//点了注册按钮的事件

(void)wdguideRegisterBtnClick:(UIButton *)btn 

//点击登录按钮的事件

(void)wdguideLoginBtnClick:(UIButton *)btn

如果有什么意见或者建议,请与我联系  514335620@qq.com 
