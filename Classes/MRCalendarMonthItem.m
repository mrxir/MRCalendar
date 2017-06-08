//
//  MRCalendarMonthItem.m
//  Calendar
//
//  Created by 🍉 on 2017/6/2.
//  Copyright © 2017年 🍉. All rights reserved.
//

#import "MRCalendarMonthItem.h"

@interface MRCalendarMonthItem ()

@property (nonatomic, weak) IBOutlet UILabel *yearLabel;

@property (nonatomic, weak) IBOutlet UILabel *monthLabel;

@property (nonatomic, strong) CAShapeLayer *monthItemSeparatorLineLayer;

@end

@implementation MRCalendarMonthItem

#pragma mark - INIT

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [self loadNibWithFrame:frame];
    }
    return self;
}

- (instancetype)loadNibWithFrame:(CGRect)frame
{
    
#if TARGET_INTERFACE_BUILDER
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
#else
    NSBundle *bundle = [NSBundle mainBundle];
#endif
    
    MRCalendarMonthItem *item = [bundle loadNibNamed:@"MRCalendarMonthItem"
                                               owner:nil
                                             options:nil].firstObject;
    item.frame = frame;
    
    return item;
}

#pragma mark - SETTER AND GETTER

- (void)setYear:(NSString *)year
{
    if (![_year isEqualToString:year]) {
        
        _year = year;
        
        [self setNeedsLayout];
        
    }
}

- (void)setMonth:(NSString *)month
{
    if (![_month isEqualToString:month]) {
        
        _month = month;
        
        [self setNeedsLayout];
    }
}

#pragma mark - LAYOUT

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutYearLabelIfNeed];
    
    [self layoutMonthLabelIfNeed];
}

- (void)layoutYearLabelIfNeed
{
    self.yearLabel.text = self.year;
}

- (void)layoutMonthLabelIfNeed
{
    self.monthLabel.text = self.month;
    
    [self drawMonthItemSeparatorLineIfNeed];
}

- (void)drawMonthItemSeparatorLineIfNeed
{
    if (!self.monthItemSeparatorLineLayer) {
        self.monthItemSeparatorLineLayer = [CAShapeLayer layer];
        self.monthItemSeparatorLineLayer.fillColor = [UIColor colorWithRed:245.0/255 green:246.0/255 blue:247.0/255 alpha:1].CGColor;
        [self.layer addSublayer:self.monthItemSeparatorLineLayer];
    }
    
    CGRect monthItemSeparatorLineLayerFrame = CGRectMake(0,
                                                         CGRectGetHeight(self.bounds) - 0.5f,
                                                         CGRectGetWidth(self.bounds),
                                                         0.5f);
    self.monthItemSeparatorLineLayer.frame = monthItemSeparatorLineLayerFrame;
    
    if (!self.monthItemSeparatorLineLayer.path) {
        UIBezierPath *monthItemSeparatorLinePath = [UIBezierPath bezierPathWithRect:self.monthItemSeparatorLineLayer.bounds];
        self.monthItemSeparatorLineLayer.path = monthItemSeparatorLinePath.CGPath;
    }
    
}

@end
