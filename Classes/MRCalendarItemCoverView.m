//
//  MRCalendarItemCoverView.m
//  Calendar
//
//  Created by 🍉 on 2017/6/5.
//  Copyright © 2017年 🍉. All rights reserved.
//

#import "MRCalendarItemCoverView.h"

NSString * const MRCalendarItemCoverViewStyleNone = 0x0;

NSString * const MRCalendarItemCoverViewStyleDirectionLeft = @"<-]";

NSString * const MRCalendarItemCoverViewStyleDirectionRight = @"[->";

NSString * const MRCalendarItemCoverViewStyleDirectionClose = @"[-]";

NSString * const MRCalendarItemCoverViewStyleDirectionLeftAndRight = @"<->";

@interface MRCalendarItemCoverView ()

/**
 [-]
 */
@property (nonatomic, strong) CAShapeLayer *closedCircularLayer;

/**
 <-
 */
@property (nonatomic, strong) CAShapeLayer *leftRectangularLayer;

/**
 ->
 */
@property (nonatomic, strong) CAShapeLayer *rightRectangularLayer;

/**
 <->
 */
@property (nonatomic, strong) CAShapeLayer *leftToRightRectangularLayer;

@end

@implementation MRCalendarItemCoverView

#pragma mark - INIT

- (instancetype)initWithStyle:(NSString *)style
{
    if (self = [super init]) {
        
        self.style = style;
        
    }
    return self;
}

#pragma mark - SETTER AND GETTER

- (void)setStyle:(NSString *)style
{
    _style = style;
    
    [self setNeedsLayout];
    
}

#pragma mark - LAYOUT

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self drawCoverViewStyleDirectionLeftIfNeed];
    
    [self drawCoverViewStyleDirectionRightIfNeed];
    
    [self drawCoverViewStyleDirectionCloseIfNeedInternal:NO];
    
    [self drawCoverViewStyleDirectionLeftAndRightIfNeed];
    
}

- (void)drawCoverViewStyleDirectionLeftIfNeed
{
    if ([self.style isEqualToString:MRCalendarItemCoverViewStyleDirectionLeft]) {
        
        if (!self.leftRectangularLayer) {
            self.leftRectangularLayer = [CAShapeLayer layer];
            self.leftRectangularLayer.fillColor = [UIColor colorWithRed:215.0/255 green:230.0/255 blue:253.0/255 alpha:1].CGColor;
            [self.layer addSublayer:self.leftRectangularLayer];
        }
        
        CGRect leftRectangularLayerFrame = CGRectMake(0,
                                                      0.1 * CGRectGetHeight(self.bounds),
                                                      0.5 * CGRectGetWidth(self.bounds),
                                                      0.8 * CGRectGetHeight(self.bounds));
        self.leftRectangularLayer.frame = leftRectangularLayerFrame;
        
        if (!self.leftRectangularLayer.path) {
            UIBezierPath *leftRectangularPath = [UIBezierPath bezierPathWithRect:self.leftRectangularLayer.bounds];
            self.leftRectangularLayer.path = leftRectangularPath.CGPath;
        }
        
        [self drawCoverViewStyleDirectionCloseIfNeedInternal:YES];
        
    }
    
}

- (void)drawCoverViewStyleDirectionRightIfNeed
{
    if ([self.style isEqualToString:MRCalendarItemCoverViewStyleDirectionRight]) {
        
        if (!self.rightRectangularLayer) {
            self.rightRectangularLayer = [CAShapeLayer layer];
            self.rightRectangularLayer.fillColor = [UIColor colorWithRed:215.0/255 green:230.0/255 blue:253.0/255 alpha:1].CGColor;
            [self.layer addSublayer:self.rightRectangularLayer];
        }
        
        CGRect rightRectangularLayerFrame = CGRectMake(0.5 * CGRectGetWidth(self.bounds),
                                                       0.1 * CGRectGetHeight(self.bounds),
                                                       0.5 * CGRectGetWidth(self.bounds),
                                                       0.8 * CGRectGetHeight(self.bounds));
        self.rightRectangularLayer.frame = rightRectangularLayerFrame;
        
        if (!self.rightRectangularLayer.path) {
            UIBezierPath *rightRectangularPath = [UIBezierPath bezierPathWithRect:self.rightRectangularLayer.bounds];
            self.rightRectangularLayer.path = rightRectangularPath.CGPath;
        }
        
        [self drawCoverViewStyleDirectionCloseIfNeedInternal:YES];
        
    }
}

- (void)drawCoverViewStyleDirectionCloseIfNeedInternal:(BOOL)isNeed
{
    
    if ([self.style isEqualToString:MRCalendarItemCoverViewStyleDirectionClose] || isNeed) {
        
        if (!self.closedCircularLayer) {
            self.closedCircularLayer = [CAShapeLayer layer];
            self.closedCircularLayer.fillColor = [UIColor colorWithRed:166.0/255 green:191.0/255 blue:249.0/255 alpha:1].CGColor;
            [self.layer addSublayer:self.closedCircularLayer];
        }
        
        CGRect closedCircularLayerFrame = CGRectMake(0.1 * CGRectGetWidth(self.bounds),
                                                     0.1 * CGRectGetHeight(self.bounds),
                                                     0.8 * CGRectGetWidth(self.bounds),
                                                     0.8 * CGRectGetHeight(self.bounds));
        self.closedCircularLayer.frame = closedCircularLayerFrame;
        
        if (!self.closedCircularLayer.path) {
            UIBezierPath *closedCircularPath = [UIBezierPath bezierPathWithRoundedRect:self.closedCircularLayer.bounds
                                                                          cornerRadius:CGRectGetHeight(self.closedCircularLayer.bounds)/2];
            self.closedCircularLayer.path = closedCircularPath.CGPath;
        }
        
    }
    
}

- (void)drawCoverViewStyleDirectionLeftAndRightIfNeed
{
    if ([self.style isEqualToString:MRCalendarItemCoverViewStyleDirectionLeftAndRight]) {
        
        if (!self.leftToRightRectangularLayer) {
            self.leftToRightRectangularLayer = [CAShapeLayer layer];
            self.leftToRightRectangularLayer.fillColor = [UIColor colorWithRed:215.0/255 green:230.0/255 blue:253.0/255 alpha:1].CGColor;
            [self.layer addSublayer:self.leftToRightRectangularLayer];
        }
        
        CGRect leftToRightRectangularLayerFrame = CGRectMake(0,
                                                             0.1 * CGRectGetHeight(self.bounds),
                                                             CGRectGetWidth(self.bounds),
                                                             0.8 * CGRectGetHeight(self.bounds));
        self.leftToRightRectangularLayer.frame = leftToRightRectangularLayerFrame;
        
        if (!self.leftToRightRectangularLayer.path) {
            UIBezierPath *leftToRightRectangularPath = [UIBezierPath bezierPathWithRect:self.leftToRightRectangularLayer.bounds];
            self.leftToRightRectangularLayer.path = leftToRightRectangularPath.CGPath;
        }
        
    }
}

@end
