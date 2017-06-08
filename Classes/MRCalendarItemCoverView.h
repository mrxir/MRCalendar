//
//  MRCalendarItemCoverView.h
//  Calendar
//
//  Created by 🍉 on 2017/6/5.
//  Copyright © 2017年 🍉. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 0x0 无样式
 */
UIKIT_EXTERN NSString * const MRCalendarItemCoverViewStyleNone;

/**
 <-] 左开右闭
 */
UIKIT_EXTERN NSString * const MRCalendarItemCoverViewStyleDirectionLeft;

/**
 [-> 左闭右开
 */
UIKIT_EXTERN NSString * const MRCalendarItemCoverViewStyleDirectionRight;

/**
 [-] 左闭右闭
 */
UIKIT_EXTERN NSString * const MRCalendarItemCoverViewStyleDirectionClose;

/**
 <-> 左开右开
 */
UIKIT_EXTERN NSString * const MRCalendarItemCoverViewStyleDirectionLeftAndRight;

@interface MRCalendarItemCoverView : UIView

@property (nonatomic, copy) NSString *style;

- (instancetype)initWithStyle:(NSString *)style;

@end
