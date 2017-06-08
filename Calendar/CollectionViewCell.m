//
//  CollectionViewCell.m
//  Calendar
//
//  Created by 🍉 on 2017/6/1.
//  Copyright © 2017年 🍉. All rights reserved.
//

#import "CollectionViewCell.h"

#import "MRCalendar.h"

@interface CollectionViewCell ()

@end

@implementation CollectionViewCell

- (void)prepareDisplay
{
    self.calendar.year = self.currentYear;
    self.calendar.months = (id)@[self.currentMonthUploadRecord[@"month"]];
    self.calendar.days = (id)self.currentMonthUploadRecord[@"days"];
}

@end
