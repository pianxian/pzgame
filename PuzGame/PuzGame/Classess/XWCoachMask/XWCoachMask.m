//
//  XWCoachMask.m
//  XWSuperWidgetDemo
//
//  Created by 王剑石 on 17/1/6.
//  Copyright © 2017年 王剑石. All rights reserved.
//

#import "XWCoachMask.h"


static const CGFloat kAnimationDuration = 0.3f;
static const CGFloat kMaskAlpha = 0.5f;
static const CGFloat kMaskRadius = 5.0f;
static const CGFloat kLblSpacing = 35.0f;
static const CGFloat kLabelMargin = 5.0f;


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
@interface XWCoachMask () <CAAnimationDelegate>
#else
@interface XWCoachMask ()
#endif

@property (nonatomic, strong) CAShapeLayer *mask;

@property (nonatomic, strong) UIImageView *arrowImage;

@property (nonatomic, strong) UILabel     *tipLab;

@property (nonatomic, strong) NSMutableArray *coachMasks;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation XWCoachMask

-(instancetype)initWithFrame:(CGRect)frame coachMasks:(NSArray<XWMaskItem *> *)masks{
    
    if (self = [self initWithFrame:frame]) {
        
        
        [self.coachMasks addObjectsFromArray:masks];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
     
        [self setup];
    }
    return self;
}

-(void)setup{
    
    self.coachMasks = [[NSMutableArray alloc] init];
    
    self.mask = [CAShapeLayer layer];
    [self.mask setFillRule:kCAFillRuleEvenOdd];
    [self.mask setFillColor:[[UIColor blackColor] colorWithAlphaComponent:kMaskAlpha].CGColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.mask.path = maskPath.CGPath;
    [self.layer addSublayer:self.mask];
    
    // gesture
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    // creat tipLab
    self.tipLab = [[UILabel alloc] initWithFrame:(CGRect){{0.0f, 0.0f}, {0, 0.0f}}];
    self.tipLab.backgroundColor = [UIColor clearColor];
    self.tipLab.textColor = [UIColor whiteColor];
    self.tipLab.font = [UIFont systemFontOfSize:13.0f];
    self.tipLab.lineBreakMode = NSLineBreakByWordWrapping;
    self.tipLab.numberOfLines = 0;
    self.tipLab.textAlignment = NSTextAlignmentCenter;
    self.tipLab.alpha = 0.0f;
    [self addSubview:self.tipLab];

    
    
    self.hidden = YES;

}

-(XWCoachMask *(^)(XWMaskItem *))add{
    
    return ^XWCoachMask *(XWMaskItem *mask){
        
        [self.coachMasks addObject:mask];
        
        return self;
    };
}

-(void)showCoachMaskInview:(UIView *)superView{
    
    self.alpha = 0.0f;
    self.hidden = NO;
    if (superView) {
        
        [superView addSubview:self];
    }
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [self showCoachMarkIndexed:0];
                     }];

}

-(void)handleDidTap:(UIGestureRecognizer *)gesture{
    
    
    [self showCoachMarkIndexed:self.currentIndex + 1];
}

#pragma mark -  modify

- (void)switchMaskWithRect:(CGRect)rect withShape:(XWMaskItem *)maskItem animate:(BOOL )animate{
   
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *subMaskPath;

    switch (maskItem.maskShap) {
        case SHAPE_CIRCLE:
            subMaskPath = [UIBezierPath bezierPathWithOvalInRect:rect];
            break;
        case SHAPE_SQUARE:
            subMaskPath = [UIBezierPath bezierPathWithRect:rect];
            break;
        case SHAPE_CUSTOME:
            subMaskPath = maskItem.maskPath;
            break;
        default:
            subMaskPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:kMaskRadius];
            break;
    }
    
    [maskPath appendPath:subMaskPath];
    
    if (animate) {
        
        //add animation
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        anim.duration = kAnimationDuration;
        anim.removedOnCompletion = NO;
        anim.delegate = self;
        anim.fillMode = kCAFillModeForwards;
        anim.fromValue = (__bridge id)(self.mask.path);
        anim.toValue = (__bridge id)(maskPath.CGPath);
        [self.mask addAnimation:anim forKey:@"path"];
        self.mask.path = maskPath.CGPath;
    }else{
        
        self.mask.path = maskPath.CGPath;
        
        [self showTipLabWithAnimatend];

    }
    
   
    
}

- (void)showCoachMarkIndexed:(NSUInteger)index {
    
    if (index >= self.coachMasks.count) {
        [self cleanup];
        return;
    }
    
    self.currentIndex = index;
    
    XWMaskItem *maskItem = [self.coachMasks objectAtIndex:index];
    
    CGRect markRect = maskItem.maskRect;

    [self.arrowImage removeFromSuperview];
    BOOL showArrow = maskItem.showArrowImage;
    
    self.tipLab.alpha = 0.0f;
    CGFloat width = [maskItem.tipTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size.width;
    self.tipLab.frame = (CGRect){{0, 0}, {width,40.0f}};
    self.tipLab.text = maskItem.tipTitle;
    [self.tipLab sizeToFit];
    CGFloat y;
    CGFloat x;
    
    switch (maskItem.labPosition) {
        case TIP_POSITION_TOP:
        {
            y = markRect.origin.y - self.tipLab.frame.size.height - kLabelMargin;
            x = markRect.origin.x + markRect.size.width/2.0 - self.tipLab.frame.size.width/2.0;
            if(showArrow) {
                
                UIImage *image = [self fetchImage:maskItem.arrowImage.length > 0 ? maskItem.arrowImage : @"arrow-down"];
                y = markRect.origin.y - image.size.height - kLabelMargin;
                [self addArrowimageWithName:image imageRect:CGRectMake( markRect.origin.x + markRect.size.width/2.0 - image.size.width/2.0, y, 0, 0)];
                y -= (self.arrowImage.frame.size.height + kLabelMargin);
                
            }
        }
            break;
        case TIP_POSITION_BOTTOM:
        {
            y = markRect.origin.y + markRect.size.height + kLabelMargin;
            x = markRect.origin.x + markRect.size.width/2.0 - self.tipLab.frame.size.width/2.0;
            if(showArrow) {
                
                UIImage *image = [self fetchImage:maskItem.arrowImage.length > 0 ? maskItem.arrowImage : @"arrow-down"];
                [self addArrowimageWithName:image imageRect:CGRectMake(markRect.origin.x + markRect.size.width/2.0 - image.size.width/2.0, y, 0, 0)];
                y += (self.arrowImage.frame.size.height + kLabelMargin);
                
            }
        }
            break;

        case TIP_POSITION_LEFT:
        {
            y = markRect.origin.y + markRect.size.height/2 - self.tipLab.frame.size.height/2;
            x = self.bounds.size.width - self.tipLab.frame.size.width - kLabelMargin - (self.bounds.size.width - markRect.origin.x );
            if(showArrow) {
                UIImage *image = [self fetchImage:maskItem.arrowImage.length > 0 ? maskItem.arrowImage : @"arrow-right"];

                [self addArrowimageWithName:image imageRect:CGRectMake(self.bounds.size.width - image.size.width - kLabelMargin - (self.bounds.size.width - markRect.origin.x ), markRect.origin.y + markRect.size.height/2 - image.size.height/2, 0, 0)];
                
                x -= (self.arrowImage.frame.size.width + kLabelMargin);
              
            }
        }
            break;
        case TIP_POSITION_RIGHT:
        {
            y = markRect.origin.y + markRect.size.height/2 - self.tipLab.frame.size.height/2;
            x = markRect.origin.x + markRect.size.width + kLabelMargin;
            if(showArrow) {
                
            }
        }
            break;
        case TIP_POSITION_RIGHT_BOTTOM:
        {
            y = markRect.origin.y + markRect.size.height + kLabelMargin;
            CGFloat bottomY = y + self.tipLab.frame.size.height + kLabelMargin;
            if (bottomY > self.bounds.size.height) {
                y = markRect.origin.y - kLblSpacing - self.tipLab.frame.size.height;
            }
            x = markRect.origin.x + markRect.size.width + kLabelMargin;
            
            UIImage *image = [self fetchImage:maskItem.arrowImage.length > 0 ? maskItem.arrowImage : @"arrow-top"];
            
            [self addArrowimageWithName:image imageRect:CGRectMake(x - markRect.size.width/2 - image.size.width/2, y , 0, 0)];
            
             y = y + kLabelMargin + image.size.height/2;
        }
            break;
        default: {
            
        }
            break;
    }
    
    self.tipLab.frame = (CGRect){{x, y}, {width,40.0f}};
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xwMaskView:willSwitchToIndex:)]) {
        
        [self.delegate xwMaskView:self willSwitchToIndex:self.currentIndex];
    }
    
    [self switchMaskWithRect:maskItem.maskRect withShape:maskItem animate:self.currentIndex != 0];
    
    
}

- (UIImage*)fetchImage:(NSString*)name {
    
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageNamed:name];
    }
}

-(void)addArrowimageWithName:(UIImage *)image imageRect:(CGRect )rect{
    
    self.arrowImage = [[UIImageView alloc] initWithImage:image];
    CGRect imageViewFrame = self.arrowImage.frame;
    imageViewFrame.origin.x = rect.origin.x;
    imageViewFrame.origin.y = rect.origin.y;
    self.arrowImage.frame = imageViewFrame;
   // [self addSubview:self.arrowImage];

}

-(void)showTipLabWithAnimatend{
    
    XWMaskItem *maskItem = [self.coachMasks objectAtIndex:self.currentIndex];
    
    if (maskItem.showArrowImage) {
        
        [self addSubview:self.arrowImage];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.tipLab.alpha = 1.0f;
    }];

}

#pragma mark - Cleanup

- (void)cleanup {
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
  
                     }];
}

#pragma mark - Animation delegate

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    
    [self showTipLabWithAnimatend];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xwMaskView:didSwitchToIndex:)]) {
        
        [self.delegate xwMaskView:self didSwitchToIndex:self.currentIndex];
    }
}

@end
