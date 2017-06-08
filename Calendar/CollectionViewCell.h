//
//  CollectionViewCell.h
//  Calendar
//
//  Created by 🍉 on 2017/6/1.
//  Copyright © 2017年 🍉. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRCalendar.h"

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *currentYear;

@property (nonatomic, strong) NSDictionary *currentMonthUploadRecord;

@property (nonatomic, weak) IBOutlet MRCalendar *calendar;

- (void)prepareDisplay;

@end
