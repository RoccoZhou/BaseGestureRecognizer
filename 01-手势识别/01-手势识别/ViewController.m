//
//  ViewController.m
//  01-手势识别
//
//  Created by Rocco on 15/12/21.
//  Copyright © 2015年 Rocco. All rights reserved.
//

/**
 * 主要功能：
   1) 双指双击图片的右半边
   2) 长按图片能开启或结束图片的拖拽
   3) 可向上轻扫 图片
   4) 双指缩放图片
   5) 双指旋转图片
 
 * 未解问题：
   1) 长按图片结束拖拽时，图片的位置会恢复 最初的位置。
 */


#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelView;

@property (nonatomic, strong) UIPanGestureRecognizer *panGest;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 使能UIImageView的接收用户响应事件
    self.imageView.userInteractionEnabled = true;
    
    /**
     * 默认情况下，控件只能 监听到一种 手势
     * 如果要监听到多个手势，设置一个代理的方法，告知它允许 ”多个手势“ 并存
     */
    
    // 【轻击手势】
    // 1. 实例化 轻击手势
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    // 2. 设置 轻击手势的相关属性   -- 设计成同时两个手指双击图片的右侧
    // 2.1 响应方法回调要满足的点击次数
    tapGest.numberOfTapsRequired = 2;
    // 2.2 响应方法回调要满足的点击手指数
    tapGest.numberOfTouchesRequired = 2;
    // 3. 添加到相应的View中
    [self.imageView addGestureRecognizer:tapGest];
    
    // 【长按手势】
    // 1. 新建 长按手势 对象
    UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressView:)];
    // 2.1 设置长按时间
    longPressGest.minimumPressDuration = 1.0; // 1秒
    // 2.2 触摸点周围多远的距离内长按有效
    longPressGest.allowableMovement = 20;
    // 3. 添加到相应的View中
    [self.imageView addGestureRecognizer:longPressGest];
    
    
    // 【轻扫手势】
    // 如果要要添加多个轻扫方向，就得添加多个轻扫手势，不过回调的是同一个方法。
    // 1. 新建 轻扫手势
    UISwipeGestureRecognizer *swipeGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    // 2.1 轻扫手指数
    swipeGest.numberOfTouchesRequired = 1;
    // 2.2 轻扫方向
    swipeGest.direction = UISwipeGestureRecognizerDirectionUp;
    // 3. 添加到相应的View中
    [self.imageView addGestureRecognizer:swipeGest];
    
    
    // 【拖拽手势】
    // 1. 拖拽手势 实例化
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    // 2. 添加到相应的View中
    [self.imageView addGestureRecognizer:panGest];
    self.panGest.enabled = false;
    
    // 【捏合手势】
    // 1.
    UIPinchGestureRecognizer *pinchGest = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    // 2. 添加到相应的View中
    [self.imageView addGestureRecognizer:pinchGest];
    
    // 【旋转手势】
    // 1.
    UIRotationGestureRecognizer *rotationGest = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationView:)];
    // 2.
    [self.imageView addGestureRecognizer:rotationGest];
    
}


#pragma mark - UIGestureRecognizerDelegates 手势代理相关
/**
 * 告诉 View 是否接收该触摸事件
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:touch.view];
    if (point.x > touch.view.bounds.size.width * 0.5) {
        return true;
    }
    return false;
}

/**
 * 告诉 View 是否允许 某手势 与 其它手势 并存
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - 轻击手势回调
/**
 * 轻击响应方法
 */
- (void) tapView:(UITapGestureRecognizer *)tapGest {
    self.labelView.text = @"轻击 OK";
}


#pragma mark - 长按手势回调
- (void) longPressView:(UILongPressGestureRecognizer *)longPressGest {
    /*
     UIGestureRecognizerStateBegan      开始
     UIGestureRecognizerStateChanged    改变
     UIGestureRecognizerStateEnded      结束
     UIGestureRecognizerStateCancelled  取消
     UIGestureRecognizerStateFailed     失败
     */
    
    // 判断长按手势 的开始或结束
//    NSLog(@"longPressGest status is %ld", (long)longPressGest.state);
    if (longPressGest.state == UIGestureRecognizerStateBegan) {
//        self.labelView.text = @"开始长按";
        self.panGest.enabled = !self.panGest.enabled;
        self.labelView.text = self.panGest.enabled ? @"开始拖拽" : @"结束拖拽";
        
    }
    else if (longPressGest.state == UIGestureRecognizerStateChanged) {
        
    }
}


#pragma mark - 轻扫手势回调
- (void) swipeView:(UISwipeGestureRecognizer *)swipeGest {
    /*
    UISwipeGestureRecognizerDirectionRight  向右轻扫
    UISwipeGestureRecognizerDirectionLeft   向左轻扫
    UISwipeGestureRecognizerDirectionUp     向上轻扫
    UISwipeGestureRecognizerDirectionDown   向下轻扫
     */
//    NSLog(@"%s %lu", __func__, (unsigned long)swipeGest.direction);
    self.labelView.text = @"向上轻扫";
}


#pragma mark - 拖拽手势回调
- (void) panView:(UIPanGestureRecognizer *)panGest {
    // 拖拽的距离 【距离是一个累加】
    CGPoint trans = [panGest translationInView:panGest.view];
    
    CGPoint center = self.imageView.center;
    center.x += trans.x;
    center.y += trans.y;
    self.imageView.center = center;
    
    // * 清除 累加 的距离
    [panGest setTranslation:CGPointZero inView:panGest.view];
    
    self.labelView.text = @"拖拽中";
}


#pragma mark - 捏合手势回调
- (void) pinchView:(UIPinchGestureRecognizer *)pinchView {
    // 缩放比例是一个累积值，需做还原比例为1
    // 设置图片随着缩放
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform , pinchView.scale, pinchView.scale);
    // 清除缩放比例的累加，还原比例为1
    pinchView.scale = 1;
    
    self.labelView.text = @"缩放";
}


#pragma mark - 旋转手势回调
- (void) rotationView:(UIRotationGestureRecognizer *)rotationGest {
    // 旋转角度 也是一个累积过程
    // 设置图片旋转
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, rotationGest.rotation);
    // 清除旋转角度的累积
    rotationGest.rotation = 0;
    
    self.labelView.text = @"旋转";
}


#pragma mark - 主View轻击
- (IBAction)tapMainView:(UITapGestureRecognizer *)sender {
    self.labelView.text = @"长按可拖拽";
}



@end
