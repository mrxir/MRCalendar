//
//  MRCalendarItem.m
//  Calendar
//
//  Created by 🍉 on 2017/6/1.
//  Copyright © 2017年 🍉. All rights reserved.
//

#import "MRCalendarItem.h"

@interface MRCalendarItem ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) MRCalendarItemCoverView *coverView;

@end

@implementation MRCalendarItem

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
    MRCalendarItem *item = [bundle loadNibNamed:@"MRCalendarItem"
                                          owner:nil
                                        options:nil].firstObject;
    item.frame = frame;
    
    return item;
}

#pragma mark - SETTER AND GETTER

- (void)setTitle:(NSString *)title
{
    if (![_title isEqualToString:title]) {
        
        _title = title;
        
        [self setNeedsLayout];
        
    }
}

- (void)setItemStyle:(NSUInteger)itemStyle
{
    if (_itemStyle != itemStyle) {
        
        _itemStyle = itemStyle;
        
        [self setNeedsLayout];
        
    }
}

- (void)setCoverStyle:(NSString *)coverStyle
{
    if (![_coverStyle isEqualToString:coverStyle]) {
        
        _coverStyle = coverStyle;
        
        [self setNeedsLayout];
        
    }
}

#pragma mark - LAYOUT

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // ** 以下方法不可调换调用顺序 **//
    
    // 设置 cover view 样式
    [self layoutCoverViewIfNeed];
    
    // 全局设置样式
    [self layoutItemStyleIfNeed];
    
    // 部分设置样式, 会根据 cover view style 来设置不同的 title label 样式
    [self layoutTitleLabelIfNeed];
    
}

- (void)layoutCoverViewIfNeed
{
    [self.coverView removeFromSuperview];
    
    if (self.coverStyle) {
        self.coverView = [[MRCalendarItemCoverView alloc] initWithStyle:self.coverStyle];
        [self insertSubview:self.coverView atIndex:0];
        self.coverView.frame = self.bounds;
    }
    
}

- (void)layoutItemStyleIfNeed
{
    switch (self.itemStyle) {
        case MRCalendarItemStyleLastMonth: {
            
            self.titleLabel.textColor = [UIColor lightGrayColor];
            
        } break;
            
        case MRCalendarItemStyleNextMonth: {
            
            self.titleLabel.textColor = [UIColor grayColor];
            
        } break;
            
        case MRCalendarItemStyleCurrentMonth: {
            
            self.titleLabel.textColor = [UIColor blackColor];
            
        } break;
            
        case MRCalendarItemStyleWeekday: {
            
            self.titleLabel.textColor = [UIColor darkGrayColor];
            
        } break;
            
        default: {
            
            self.titleLabel.textColor = [UIColor blackColor];
            
        } break;
    }
}

- (void)layoutTitleLabelIfNeed
{
    self.titleLabel.text = self.title;
    
    if (self.coverStyle) {
        if ([self.coverStyle isEqualToString:MRCalendarItemCoverViewStyleNone]
            || [self.coverStyle isEqualToString:MRCalendarItemCoverViewStyleDirectionLeftAndRight]) {
            self.itemStyle = MRCalendarItemStyleCurrentMonth;
        } else {
            self.titleLabel.textColor = [UIColor whiteColor];
        }
    }
}

@end
