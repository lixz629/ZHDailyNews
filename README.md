# ZHDailyNews
一.APP简要功能介绍：
1.首页（轮播图+新闻列表）
![轮播图](GIF/轮播图.gif)
![点击新闻栏跳转](GIF/点击跳转1.gif)
![点击轮播图跳转](GIF/点击跳转2.gif)
![往期新闻](GIF/无限加载往期新闻.gif)
2.新闻详情页（跳转到知乎查看原文+底部工具栏）
![跳转到知乎查看原文](GIF/跳转到知乎查看原文.gif)
![底部工具栏](GIF/新闻底部工具栏.GIF)
3.登录界面+夜间模式
![登录界面](GIF/登录界面.gif)
![夜间模式](GIF/夜间模式.gif)

二.APP构成板块及开发思路
1.首页构成：
顶部轮播图：
SDCycleScrollView + 自定义UICollectionViewCell
SDCycleScrollView实现网络请求返回数据中的top_stories所包含图片的无限轮播
自定义cell实现每张图片对应新闻的标题及作者信息的显示

最顶部当日日期、问候语及跳转到登录界面的默认头像按钮：
当日日期与问候语采用普通的UIView布局，通过NSDateFormatter将返回的20260222这种类型的数据转换为需要展示的“二月”，“22”等数据
通过NSdate和NSCalendar中的相关方法实时获取用户当前的时间（小时），根据当前时间确定问候语的显示
点击默认头像按钮后跳转到登录界面是通过在view里为点击事件添加一个block代码块（记录登录信息），然后在ViewController里通过navigationController的pushViewController方法实现跳转

往期新闻：
通过before/date的方式请求往期新闻数据，将请求到的数据中的date字符串赋值给前面用到的字符串对象，实现无限刷新往期新闻的数据
往期新闻间的日期分割线采用和顶部日期相同的NSDateFormatter方法实现

2.新闻详情页：
顶部HeaderView：
利用SDWebImage下载并显示图片，图片上的新闻标题显示方式与首页采用的相同方式
下方跳转到知乎的蓝色字体通过UIButton实现
在detailViewController里为其添加点击事件：点击时通过UIApplication打开相应的url

中间网页内容：
利用前端知识处理详情页接口返回的html和css数据

底部工具栏：
五个按钮：
返回按钮：点击时触发navigationController的popViewController方法回到上一页面
评论按钮：点击触发navigationController的pushViewController方法跳转到CommentViewController
点赞按钮：点击切换图片样式，通过MBProgressHUD实现成功点赞和取消点赞的弹窗
收藏按钮：弹窗效果的实现与点赞按钮同理
分享按钮：点击后弹出一个自定义的shareView,shareView底部是一个白色背景的collectionView来展示自定义的shareCell，上面其余部分添加阴影效果和点击后收起弹窗的效果
评论按钮和点赞按钮右上角的评论数与点赞数通过story-extra请求数据后填充

3.登录界面：
中间的提示文字及相关按钮都集成在loginMainView里，方便布局
相关协议通过富文本（NSMutableAttributedString）实现相关字体变蓝并可通过点击跳转到相关协议界面

夜间模式：点击后记录当前按钮状态，退出后重新点进登录界面仍可保留之前的状态
具体实现：将背景设置为systemBackgroundColor,其余颜色设置为labelColor 当点击按钮时根据按钮状态设置整个应用界面的颜色状态，实现夜间模式的切换
