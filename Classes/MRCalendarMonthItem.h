//
//  MRCalendarMonthItem.h
//  Calendar
//
//  Created by 🍉 on 2017/6/2.
//  Copyright © 2017年 🍉. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface MRCalendarMonthItem : UICollectionReusableView

@property (nonatomic, copy) IBInspectable NSString *year;

@property (nonatomic, copy) IBInspectable NSString *month;

@end
