//
//  PZAnimate.m
//  PuzGame
//
//  Created by hww on 2018/7/24.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZAnimate.h"
#import "STModal.h"

@interface PZAnimate ()
{
    
    BOOL _didLayouted;
}
@property (nonatomic,strong)  STModal *stmodel;
@property (nonatomic,assign) BOOL hideWhenTapOutside;
@property (strong, nonatomic) void (^didShowHandler)(void);
@property (strong, nonatomic) void (^didHideHandler)(void);
@property (assign, nonatomic, readonly) BOOL onShow;
@end

@implementation PZAnimate
- (st_modal_animation)showAnimation{
    return ^CGFloat(){
        self.animationView.alpha = 0;
        CGFloat d1 = 0.2,d2 = 0.15;
        self.animationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
        [UIView animateWithDuration:d1 animations:^{
            self.animationView.alpha = 1;
            self.animationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:d2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.animationView.alpha = 1;
                self.animationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            } completion:^(BOOL finished2) {
            }];
        }];
        return (d1 + d2);
    };
}
- (st_modal_animation)hideAnimation{
    return ^CGFloat(){
        CGFloat d1 = 0.2,d2 = 0.1;
        [UIView animateWithDuration:d2 animations:^{
            self.animationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:d1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.animationView.alpha = 0;
                self.animationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            } completion:^(BOOL finished) {
                
            }];
        }];
        return (d2 +d1);
    };
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _didLayouted = NO;
        _hideWhenTapOutside = YES;
        _hideWhenTap = YES;
    }
    return self;
}
+ (PZAnimate *)shareAnimate{
    static dispatch_once_t onceToken;
    static PZAnimate *animate = nil;
    dispatch_once(&onceToken, ^{
        animate = [[self alloc] init];
    });
    return animate;
}

-(void)show:(BOOL)animated{
   _didLayouted = YES;
    _stmodel.hideWhenTouchOutside = [PZAnimate shareAnimate].hideWhenTapOutside;
    _stmodel.didHideHandler = [PZAnimate shareAnimate].didShowHandler;
    _stmodel.didHideHandler = [PZAnimate shareAnimate].didHideHandler;
    [_stmodel show:animated];
}

-(void)hide:(BOOL)animated{
    [_stmodel hide:animated];
}
-(BOOL)onShow{
    return _stmodel.onShow;
}
+(void)animateAcion:(void(^)(PZAnimate *base))block animationView:(UIView *)animateView{
    if (block) {
        PZAnimate *animate = [PZAnimate shareAnimate];
        animate.stmodel =   [STModal modalWithContentView:animateView];
        animate.animationView = animateView;
        animate.stmodel.hideWhenTouchOutside = YES;
        animate.stmodel.dimBackgroundWhenShow = YES;
        animate.stmodel.showAnimation = [animate showAnimation];
        animate.stmodel.hideAnimation = [animate hideAnimation];
        block(animate);
    }
}
-(void)setHideWhenTap:(BOOL)hideWhenTap{
    _hideWhenTap = hideWhenTap;
    self.animationView.userInteractionEnabled = hideWhenTap;
    [self.animationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateAction)]];
}
-(void)animateAction{
    [self hide:YES];
}
-(show)showAction{
    return ^(){
        [self show:YES];
        return self;
    };
}
-(hide)hideAction{
    return ^(){
        [self hide:YES];
        return self;
    };
}
//+(BOOL)resolveInstanceMethod:(SEL)sel{
//    NSLog(@"---%@",NSStringFromSelector(sel));
//    return [super resolveInstanceMethod:sel];
//}
//+(BOOL)resolveClassMethod:(SEL)sel{
//    NSLog(@"---222%@",NSStringFromSelector(sel));
//    return [super resolveClassMethod:sel];
//}
@end
