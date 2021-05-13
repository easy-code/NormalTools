//
//  RipplesView.m
//
//  Created by ichengfeng on 2021/05/13.
//  Copyright © 2021 ichengfeng. All rights reserved.
//

#import "RipplesView.h"

@interface RipplesView ()

@property (nonatomic, strong) CAShapeLayer *circleShapeLayer;

@property(nonatomic, strong)UIButton *btn;

@end

@implementation RipplesView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
        
        CGRect rect = self.frame;
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.tag = 200;
        self.btn.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        self.btn.layer.masksToBounds = YES;
        self.btn.layer.cornerRadius = rect.size.width/2;
        [self.btn setTitle:@"开始检测" forState:UIControlStateNormal];
        [self.btn setTitle:@"搜寻中" forState:UIControlStateSelected];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor systemBlueColor]];
        [self.btn addTarget:self action:@selector(clickeEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.btn];
        [self setUpLayers];
    }
    return self;
}

//- (void)awakeFromNib{
//    [super awakeFromNib];
//
//    self.clipsToBounds = NO;
//    self.layer.masksToBounds = NO;
//
//    CGRect rect = self.frame;
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.tag = 200;
//    btn.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = rect.size.width/2;
//    [btn setTitle:@"开始检测" forState:UIControlStateNormal];
//    [btn setTitle:@"搜寻中" forState:UIControlStateSelected];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor systemBlueColor]];
//    [btn addTarget:self action:@selector(clickeEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview: btn];
//    [self setUpLayers];
//}

- (void)setUpLayers{
    NSArray *array = [NSArray arrayWithObjects:[UIColor systemBlueColor],[UIColor systemBlueColor],[UIColor systemBlueColor],[UIColor systemBlueColor], nil];
    CGRect rect = self.frame;
    CGFloat centerPoint = rect.size.width/2;
    CGFloat radius = centerPoint+15;
    for (int i = 0; i < 4; i ++) {
        CAShapeLayer *layer = [CAShapeLayer new];
        layer.lineWidth = 1;
        UIColor *color = array[i];
        layer.strokeColor = color.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerPoint, centerPoint) radius:radius startAngle:(0) endAngle:M_PI*2 clockwise:YES];
        layer.path = [path CGPath];
        [self.layer addSublayer:layer];
        radius += 30;
    }
}

- (void)startAnimation{
    NSInteger count = self.layer.sublayers.count;
    for (NSInteger i = count; i > 0 ; i--) {
        CAShapeLayer *layer = self.layer.sublayers[i-1];
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    if (!_circleShapeLayer) {
        CGFloat width = self.bounds.size.width*3;
        CGFloat point = self.bounds.size.width;
        self.circleShapeLayer = [CAShapeLayer layer];
        _circleShapeLayer.frame = CGRectMake(0, 0, width, width);
        _circleShapeLayer.position = CGPointMake(0, 0);
        _circleShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, width)].CGPath;
        _circleShapeLayer.fillColor = [UIColor systemBlueColor].CGColor;
        _circleShapeLayer.opacity = 0.0;
        
        CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
        replicator.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
        replicator.position = CGPointMake(point, point);
        replicator.instanceDelay = 1.0;
        replicator.instanceCount = 8;
        
        [replicator addSublayer:_circleShapeLayer];
        [self.layer addSublayer:replicator];
    }
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.fromValue = [NSNumber numberWithFloat:0.3];
    alphaAnim.toValue = [NSNumber numberWithFloat:0.0];
    
    CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t = CATransform3DIdentity;
    CATransform3D t2 = CATransform3DScale(t, 0.2, 0.2, 0.0);
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
    CATransform3D t3 = CATransform3DScale(t, 1.0, 1.0, 0.0);
    scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[alphaAnim, scaleAnim];
    groupAnimation.duration = 4.0;
    groupAnimation.autoreverses = NO;
    groupAnimation.repeatCount = HUGE;
    
    [_circleShapeLayer addAnimation:groupAnimation forKey:nil];
    [self bringSubviewToFront:self.btn];
}

- (void)stopAnimation{
    [self.circleShapeLayer removeAllAnimations];
    [self setUpLayers];
    UIButton *btn = [self viewWithTag:200];
    btn.selected = NO;
}

- (void)clickeEvent:(UIButton *)btn{
    BOOL selected = btn.selected;
    if (!btn.selected) {
        [self startAnimation];
        [self bringSubviewToFront:btn];
    }else{
        [self stopAnimation];
    }
    if (self.startEventHandle) {
        self.startEventHandle(selected);
    }
    btn.selected = !selected;
}

@end
