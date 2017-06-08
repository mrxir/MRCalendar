//
//  MRCalendarItem.h
//  Calendar
//
//  Created by 🍉 on 2017/6/1.
//  Copyright © 2017年 🍉. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRCalendarItemCoverView.h"

/**
 Item 样式

 - MRCalendarItemStyleDefault: 默认样式, 当前月 Item 样式
 - MRCalendarItemStyleLastMonth: 上个月 Item 样式
 - MRCalendarItemStyleNextMonth: 下个月 Item 样式
 - MRCalendarItemStyleCurrentMonth: 当前月 Item 样式, 等同于默认样式
 */
typedef NS_ENUM(NSUInteger, MRCalendarItemStyle) {
    MRCalendarItemStyleDefault,
    MRCalendarItemStyleLastMonth,
    MRCalendarItemStyleNextMonth,
    MRCalendarItemStyleCurrentMonth,
    MRCalendarItemStyleWeekday,
};

IB_DESIGNABLE
@interface MRCalendarItem : UICollectionViewCell

@property (nonatomic, copy) IBInspectable NSString *title;

/**
 CELL 样式
 */
@property (nonatomic, assign) IBInspectable NSUInteger itemStyle;

/**
 覆盖图层样式
 MRCalendarItemCoverViewStyleNone = 0x0 = nil
 MRCalendarItemCoverViewStyleDirectionLeft
 MRCalendarItemCoverViewStyleDirectionRight
 MRCalendarItemCoverViewStyleDirectionClose
 MRCalendarItemCoverViewStyleDirectionLeftAndRight
 */
@property (nonatomic, copy) IBInspectable NSString *coverStyle;

@end
