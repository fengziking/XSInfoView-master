//
//  XSInfoView.m
//  XSInfoView
//
//  Created by 薛纪杰 on 3/16/16.
//  Copyright © 2016 薛纪杰. All rights reserved.
//

#import "XSInfoView.h"

@implementation XSInfoViewStyle

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundColor = [UIColor colorWithRed:145/255.0 green:145 / 255.0 blue:145 / 255.0 alpha:1];
        
        _imageSize = CGSizeMake(60, 60);
        
        _fontSize = 14.0;
        _textColor = [UIColor whiteColor];
        _maxLabelWidth = 200.0;
        
        _durationSeconds = 1.0;
        
        _layoutStyle = XSInfoViewLayoutStyleVertical;
    }
    return self;
}

@end

@interface XSInfoView ()
@property (strong, nonatomic) XSInfoViewStyle *style;
@end

@implementation XSInfoView

+ (void)showInfo:(NSString *)info onView:(UIView *)superView {
    XSInfoViewStyle *style = [[XSInfoViewStyle alloc] init];
    style.info = info;
    
    XSInfoView *infoView = [[XSInfoView alloc] initWithStyle:style];
    [infoView sizeToFit];

    [superView addSubview:infoView];
    [superView bringSubviewToFront:infoView];
    [infoView addCenterCons];
    
    [XSInfoView countDown:style.durationSeconds dimissView:infoView];
}

+ (void)showInfoWithStyle:(XSInfoViewStyle *)style onView:(UIView *)superView {
    XSInfoView *infoView = [[XSInfoView alloc] initWithStyle:style];
    [infoView sizeToFit];
    
    [superView addSubview:infoView];
    [superView bringSubviewToFront:infoView];
    [infoView addCenterCons];
    
    [XSInfoView countDown:style.durationSeconds dimissView:infoView];
}

+ (void)countDown:(double)duration dimissView:(UIView *)view {
    NSTimer *timer = [NSTimer timerWithTimeInterval:duration target:view selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (instancetype)initWithStyle:(XSInfoViewStyle *)style {
    self = [super init];
    if (self) {
        _style = style;
        
        [self setup];
        
        self.infoImageView.image = _style.image;
        
        self.infoLabel.text = _style.info;
        self.infoLabel.textColor = _style.textColor;
        self.infoLabel.font = [UIFont systemFontOfSize:_style.fontSize];
        self.infoLabel.preferredMaxLayoutWidth = _style.maxLabelWidth;
        
        if (_style.layoutStyle == XSInfoViewLayoutStyleVertical) {
            [self layoutVertical];
        } else {
            [self layoutHorizontal];
        }
    }
    return self;
}

- (void)setup {
    // 关闭系统的自定义布局
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.infoLabel];
    [self addSubview:self.infoImageView];
    
    self.backgroundColor = self.style.backgroundColor;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
}

- (void)addCenterCons {
    
    //跟父试图中心
    NSLayoutConstraint *horiCons = [NSLayoutConstraint
                                    constraintWithItem:self
                                    attribute:NSLayoutAttributeCenterX
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.superview
                                    attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0
                                    constant:0.0];
    NSLayoutConstraint *veriCons = [NSLayoutConstraint
                                    constraintWithItem:self
                                    attribute:NSLayoutAttributeCenterY
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.superview
                                    attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                    constant:0.0];
    
    [self.superview addConstraints:@[horiCons, veriCons]];
}

- (void)layoutVertical {
    //图片的上 居self的上+8
    NSLayoutConstraint *imageViewToTopCons = [NSLayoutConstraint
                                              constraintWithItem:self.infoImageView
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                              attribute:NSLayoutAttributeTop
                                              multiplier:1.0
                                              constant:8.0];
    NSLayoutConstraint *imageViewToHoriCons = [NSLayoutConstraint
                                               constraintWithItem:self.infoImageView
                                               attribute:NSLayoutAttributeCenterX
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:self
                                               attribute:NSLayoutAttributeCenterX
                                               multiplier:1.0
                                               constant:0.0];
    NSLayoutConstraint *imageViewWidthCons = [NSLayoutConstraint
                                              constraintWithItem:self.infoImageView
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationLessThanOrEqual
                                              toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                              multiplier:1.0
                                              constant:self.style.imageSize.width];
    NSLayoutConstraint *imageViewHeightCons = [NSLayoutConstraint
                                               constraintWithItem:self.infoImageView
                                               attribute:NSLayoutAttributeHeight
                                               relatedBy:NSLayoutRelationLessThanOrEqual
                                               toItem:nil
                                               attribute:NSLayoutAttributeNotAnAttribute
                                               multiplier:1.0
                                               constant:self.style.imageSize.height];
    
    NSLayoutConstraint *infoLabelToLeadingCons = [NSLayoutConstraint
                                                  constraintWithItem:self.infoLabel
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self
                                                  attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0
                                                  constant:8.0];
    NSLayoutConstraint *infoLabelToTrailingCons = [NSLayoutConstraint
                                                   constraintWithItem:self.infoLabel
                                                   attribute:NSLayoutAttributeTrailing
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                   attribute:NSLayoutAttributeTrailing
                                                   multiplier:1.0
                                                   constant:-8.0];
    NSLayoutConstraint *infoLabelToInfoImageViewCons;
    if (self.infoImageView.image) {
        infoLabelToInfoImageViewCons = [NSLayoutConstraint
                                        constraintWithItem:self.infoLabel
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.infoImageView
                                        attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                        constant:8.0];
    } else {
        infoLabelToInfoImageViewCons = [NSLayoutConstraint
                                        constraintWithItem:self.infoLabel
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                        attribute:NSLayoutAttributeTop
                                        multiplier:1.0
                                        constant:8.0];
    }
    NSLayoutConstraint *infoLabelToBottomCons = [NSLayoutConstraint
                                                 constraintWithItem:self.infoLabel
                                                 attribute:NSLayoutAttributeBottom
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                                 attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0
                                                 constant:-8.0];
    
    [self addConstraints:@[imageViewToTopCons, imageViewToHoriCons, imageViewWidthCons, imageViewHeightCons]];
    [self addConstraints:@[infoLabelToLeadingCons, infoLabelToTrailingCons, infoLabelToInfoImageViewCons, infoLabelToBottomCons]];
}

- (void)layoutHorizontal {
    NSLayoutConstraint *imageViewToTopCons = [NSLayoutConstraint
                                              constraintWithItem:self.infoImageView
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                              attribute:NSLayoutAttributeTop
                                              multiplier:1.0
                                              constant:8.0];
    NSLayoutConstraint *imageViewToLeadingCons = [NSLayoutConstraint
                                                  constraintWithItem:self.infoImageView
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self
                                                  attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0
                                                  constant:8.0];
    NSLayoutConstraint *imageViewToBottomCons = [NSLayoutConstraint
                                                 constraintWithItem:self.infoImageView
                                                 attribute:NSLayoutAttributeBottom
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                                 attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0
                                                 constant:-8.0];
    NSLayoutConstraint *imageViewWidthCons = [NSLayoutConstraint
                                              constraintWithItem:self.infoImageView
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationLessThanOrEqual
                                              toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                              multiplier:1.0
                                              constant:self.style.imageSize.width];
    NSLayoutConstraint *imageViewHeightCons = [NSLayoutConstraint
                                               constraintWithItem:self.infoImageView
                                               attribute:NSLayoutAttributeHeight
                                               relatedBy:NSLayoutRelationLessThanOrEqual
                                               toItem:nil
                                               attribute:NSLayoutAttributeNotAnAttribute
                                               multiplier:1.0
                                               constant:self.style.imageSize.height];
    
    NSLayoutConstraint *infoLabelToLeadingCons = [NSLayoutConstraint
                                                  constraintWithItem:self.infoLabel
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.infoImageView
                                                  attribute:NSLayoutAttributeTrailing
                                                  multiplier:1.0
                                                  constant:8.0];
    NSLayoutConstraint *infoLabelToTrailingCons = [NSLayoutConstraint
                                                   constraintWithItem:self.infoLabel
                                                   attribute:NSLayoutAttributeTrailing
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                   attribute:NSLayoutAttributeTrailing
                                                   multiplier:1.0
                                                   constant:-8.0];
    NSLayoutConstraint *infoLabelToTopCons = [NSLayoutConstraint
                                              constraintWithItem:self.infoLabel
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                              attribute:NSLayoutAttributeTop
                                              multiplier:1.0
                                              constant:8.0];
    NSLayoutConstraint *infoLabelToBottomCons = [NSLayoutConstraint
                                                 constraintWithItem:self.infoLabel
                                                 attribute:NSLayoutAttributeBottom
                                                 relatedBy:NSLayoutRelationEqual//视图关系等于
                                                 toItem:self
                                                 attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0
                                                 constant:-8.0];
    
    [self addConstraints:@[imageViewToTopCons, imageViewToLeadingCons, imageViewToBottomCons, imageViewWidthCons, imageViewHeightCons]];
    [self addConstraints:@[infoLabelToLeadingCons, infoLabelToTrailingCons, infoLabelToTopCons, infoLabelToBottomCons]];
}

- (void)dismiss {
    
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark - getters and setters
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.numberOfLines = 0;
        _infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _infoLabel;
}

- (UIImageView *)infoImageView {
    if (!_infoImageView) {
        _infoImageView = [[UIImageView alloc] init];
        _infoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoImageView;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
