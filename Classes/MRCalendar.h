//
//  MRCalendar.h
//  Calendar
//
//  Created by 🍉 on 2017/6/1.
//  Copyright © 2017年 🍉. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface MRCalendar : UICollectionView

@property (nonatomic, copy) IBInspectable NSString *year;

// 要在 year 中显示哪些月份
@property (nonatomic, strong) IBInspectable NSString /** 可以使用数组 */ *months;

// 目前只支持 months first object 中的 days
@property (nonatomic, strong) IBInspectable NSString /** 可以使用数组 */ *days;
// 该月中哪些日期应该被标记出来

/**
 应该和 NSCalendar 那个设计逻辑一样, 但是还未统一, 该属性暂时对日期分布无效, 有空再调整.
 */
@property (nonatomic, assign) IBInspectable NSUInteger firstWeekday;

@property (nonatomic, assign) IBInspectable CGFloat topSpacing;

@property (nonatomic, assign) IBInspectable CGFloat bottomSpacing;

@property (nonatomic, assign) IBInspectable CGFloat leftSpacing;

@property (nonatomic, assign) IBInspectable CGFloat rightSpacing;

@property (nonatomic, assign) IBInspectable CGFloat minLineSpacing;

+ (NSCalendar *)sharedCalendar;

+ (NSString *)getDateDescriptionWithDate:(NSDate *)date formatter:(NSString *)formatter;

+ (NSDate *)getDateWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

+ (NSDateComponents *)getDateComponentsWithDate:(NSDate *)date;

+ (NSDate *)getDateWithDateComponents:(NSDateComponents *)components;

+ (NSRange)getCalendarRangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;

@end
