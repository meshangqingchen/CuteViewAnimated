//
//  LCCuteView.m
//  实现果冻效果
//
//  Created by 智能机器人 on 16/1/12.
//  Copyright © 2016年 智能机器人. All rights reserved.
//

#import "LCCuteView.h"

#define SYS_DEVICE_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define SYS_DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MIN_HEIGHT         100



@interface LCCuteView ()
@property(nonatomic,assign)CGFloat mHeight;//小红点最小的X
@property(nonatomic,assign)CGFloat curveX;//小红点的x
@property(nonatomic,assign)CGFloat curveY;//小红点的y
@property(nonatomic,strong)UIView *cureView;
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
@property(nonatomic,strong)CADisplayLink *displayLink;//一秒执行60次，的一个定时器

@end


@implementation LCCuteView

static NSString *kX = @"curveX";
static NSString *kY = @"curveY";

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addObserver:self forKeyPath:kX options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:kY options:NSKeyValueObservingOptionOld context:nil];
       
        [self connfigShapeLayer];
        [self configCurview];
        [self confingAction];
    }
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:kX]||[keyPath isEqualToString:kY]) {
        [self updateShapLayerPath];
    }


}

-(void)updateShapLayerPath{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(SYS_DEVICE_WIDTH, 0)];
    [path addLineToPoint:CGPointMake(SYS_DEVICE_WIDTH, MIN_HEIGHT)];
    [path addQuadCurveToPoint:CGPointMake(0, MIN_HEIGHT) controlPoint:CGPointMake(_curveX, _curveY)];
    [path closePath];
    _shapeLayer.path = path.CGPath;
    
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kX];
    [self removeObserver:self forKeyPath:kY];
}

- (void)drawRect:(CGRect)rect
{
    
}

//果冻View
-(void)connfigShapeLayer{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.fillColor = [UIColor yellowColor].CGColor;
    [self.layer addSublayer:_shapeLayer];
}
//小红点
-(void)configCurview{
    self.curveX = SYS_DEVICE_WIDTH/2;
    self.curveY = MIN_HEIGHT;
    
    _cureView= [[UIView alloc]initWithFrame:CGRectMake(self.curveX, self.curveY, 3, 3)];
    _cureView.backgroundColor = [UIColor redColor];
    [self addSubview:_cureView];
}

-(void)confingAction{

    _mHeight = 100;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanAction:)];
     self.userInteractionEnabled = YES;
    [self addGestureRecognizer:pan];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calculatePath)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _displayLink.paused = YES;
    
}

-(void)handlePanAction:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [pan translationInView:self];
        
        NSLog(@"%@",NSStringFromCGPoint(point));
        
        _mHeight = point.y*0.7 + MIN_HEIGHT;
        self.curveX = SYS_DEVICE_WIDTH/2.0 + point.x;
        self.curveY = _mHeight > MIN_HEIGHT ? _mHeight : MIN_HEIGHT;
        _cureView.frame = CGRectMake(_curveX, _curveY, _cureView.frame.size.width, _cureView.frame.size.height);
    }
    else if (pan.state == UIGestureRecognizerStateEnded||
            pan.state == UIGestureRecognizerStateFailed||
             pan.state == UIGestureRecognizerStateCancelled){
    
        _displayLink.paused = NO;
        
        //给红色view添加弹簧效果
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //
            _cureView.frame = CGRectMake(SYS_DEVICE_WIDTH/2, MIN_HEIGHT, 3, 3);
            
        } completion:^(BOOL finished) {
        
            
        }];
    }
}

-(void)calculatePath{
    
    
    CALayer *layer = _cureView.layer.presentationLayer;
    self.curveY = layer.position.x;
    self.curveY = layer.position.y;
}






























@end
