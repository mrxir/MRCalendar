//
//  MRCalendar.m
//  Calendar
//
//  Created by 🍉 on 2017/6/1.
//  Copyright © 2017年 🍉. All rights reserved.
//

#import "MRCalendar.h"

#import "MRCalendarItem.h"

#import "MRCalendarMonthItem.h"

IB_DESIGNABLE

@interface MRCalendar ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *monthArray;

@property (nonatomic, strong) NSArray *dayArray;

@property (nonatomic, strong) NSArray *segmentationDayArray;

@property (nonatomic, strong) NSDictionary *itemCoverViewStyleDictionary;

@end

@implementation MRCalendar

#pragma mark - PUBLIC GETTER METHOD

+ (NSCalendar *)sharedCalendar
{
    static NSCalendar *s_calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_calendar = [NSCalendar currentCalendar];
        [s_calendar setFirstWeekday:1];
    });
    
    return s_calendar;
}

+ (NSDateComponents *)getDateComponentsWithDate:(NSDate *)date
{
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday;
    
    NSDateComponents *components = [[MRCalendar sharedCalendar] components:unit fromDate:date];
    
    return components;

}

+ (NSDate *)getDateWithDateComponents:(NSDateComponents *)components
{
    NSDate *date = [[MRCalendar sharedCalendar] dateFromComponents:components];
    
    return date;
}

+ (NSRange)getCalendarRangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date
{
    NSRange range = [[MRCalendar sharedCalendar] rangeOfUnit:smaller inUnit:larger forDate:date];
    
    return range;
}

#pragma mark - INIT

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    
    if (!self.collectionViewLayout) {
        self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    
    // 设置代理数据源
    self.dataSource = self;
    self.delegate = self;
    
    // 注册重用标识
    [self registerClass:[MRCalendarItem class] forCellWithReuseIdentifier:@"Day"];
    [self registerClass:[MRCalendarMonthItem class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
    withReuseIdentifier:@"Month"];
    
    NSDateFormatter *yearDateFormatter = [[NSDateFormatter alloc] init];
    yearDateFormatter.dateFormat = @"yyyy";
    
    NSDateFormatter *monthDateFormatter = [[NSDateFormatter alloc] init];
    monthDateFormatter.dateFormat = @"M";
    
    NSDate *date = [NSDate date];
    
    // 默认显示当年
    self.year = [monthDateFormatter stringFromDate:date];
    
    // 默认显示当前月份
    self.months = [monthDateFormatter stringFromDate:date];
    
    // 设置默认背景色白色
    self.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - SETTER

- (void)setYear:(NSString *)year
{
    if (![_year isEqualToString:year]) {
     
        _year = year;
        
        [self reloadData];

    }
}

- (void)setMonths:(NSString *)months
{
    if (![_months isEqual:months]) {
    
        _months = months;
        
        NSMutableArray *monthComponents = nil;
        
        if ([months isKindOfClass:[NSString class]]) {
            
            monthComponents = [NSMutableArray arrayWithArray:[_months componentsSeparatedByString:@","]];
            [monthComponents removeObjectsInArray:@[@""]];
            
            self.monthArray = monthComponents;
            
        } else if ([months isKindOfClass:[NSArray class]]) {
            
            monthComponents = [NSMutableArray arrayWithArray:(id)_months];
            [monthComponents removeObjectsInArray:@[@""]];
            
            self.monthArray = monthComponents;
            
        } else {
            
            NSLog(@" | * 注意: 无法读取当前欲加载的月份数据");
            
        }
        
        [self reloadData];
        
    }
}

- (void)setDays:(NSString *)days
{
    if (![_days isEqual:days]) {
        
        _days = days;
        
        NSMutableArray *dayComponents = nil;
        
        if ([days isKindOfClass:[NSString class]]) {
            
            dayComponents = [NSMutableArray arrayWithArray:[_days componentsSeparatedByString:@","]];
            [dayComponents removeObjectsInArray:@[@""]];
            
            self.dayArray = dayComponents;
            
        } else if ([days isKindOfClass:[NSArray class]]) {
            
            dayComponents = [NSMutableArray arrayWithArray:(id)_days];
            [dayComponents removeObjectsInArray:@[@""]];
            
            self.dayArray = dayComponents;;
            
        } else {
            
            NSLog(@" | * 注意: 无法读取当前欲加载的日期数据");
            
        }
        
        self.segmentationDayArray= [self getSegmentationArrayWithConsecutiveNumberInArray:self.dayArray];
        
        self.itemCoverViewStyleDictionary = [self getItemCoverViewStyleDictionaryWithSegmentationArray:self.segmentationDayArray];
        
        [self reloadData];
        
    }
}

- (void)setFirstWeekday:(NSUInteger)firstWeekday
{
    if (_firstWeekday != firstWeekday) {
        
        firstWeekday = MAX(firstWeekday, 1);
        
        firstWeekday = MIN(firstWeekday, 7);
        
        _firstWeekday = firstWeekday;
        
        [[MRCalendar sharedCalendar] setFirstWeekday:_firstWeekday];
        
        [self reloadData];
        
    }
}

- (void)setTopSpacing:(CGFloat)topSpacing
{
    if (_topSpacing != topSpacing) {
        
        _topSpacing = topSpacing;
        
        [self reloadData];
        
    }
}

- (void)setBottomSpacing:(CGFloat)bottomSpacing
{
    if (_bottomSpacing != bottomSpacing) {
        
        _bottomSpacing = bottomSpacing;
        
        [self reloadData];
        
    }
}

- (void)setLeftSpacing:(CGFloat)leftSpacing
{
    if (_leftSpacing != leftSpacing) {
        
        _leftSpacing = leftSpacing;
        
        CGFloat availableCollectionWidth = CGRectGetWidth(self.bounds) - _leftSpacing - _rightSpacing;
        
        CGFloat availableItemFloatWidth = availableCollectionWidth / [self getDayCountOfWeek];
        
        NSUInteger availableItemIntegerWidth = availableCollectionWidth / [self getDayCountOfWeek];
        
        BOOL availableItemWidthIsInteger = availableItemFloatWidth == availableItemIntegerWidth;
        
        if (!availableItemWidthIsInteger) {
            
            CGFloat restWidth = availableCollectionWidth - availableItemIntegerWidth * [self getDayCountOfWeek];
            
            _leftSpacing = _leftSpacing + restWidth / 2.0f;
            
            _rightSpacing = _rightSpacing + restWidth / 2.0f;
            
        }
        
        [self reloadData];
        
    }
}

- (void)setRightSpacing:(CGFloat)rightSpacing
{
    if (_rightSpacing != rightSpacing) {
        
        _rightSpacing = rightSpacing;
        
        CGFloat availableCollectionWidth = CGRectGetWidth(self.bounds) - _leftSpacing - _rightSpacing;
        
        CGFloat availableItemFloatWidth = availableCollectionWidth / [self getDayCountOfWeek];
        
        NSUInteger availableItemIntegerWidth = availableCollectionWidth / [self getDayCountOfWeek];
        
        BOOL availableItemWidthIsInteger = availableItemFloatWidth == availableItemIntegerWidth;
        
        if (!availableItemWidthIsInteger) {
            
            CGFloat restWidth = availableCollectionWidth - availableItemIntegerWidth * [self getDayCountOfWeek];
            
            _leftSpacing = _leftSpacing + restWidth / 2.0f;
            
            _rightSpacing = _rightSpacing + restWidth / 2.0f;
            
        }
        
        [self reloadData];
        
    }
}

- (void)setMinLineSpacing:(CGFloat)minLineSpacing
{
    if (_minLineSpacing != minLineSpacing) {
        
        _minLineSpacing = minLineSpacing;
        
        [self reloadData];
        
    }
}

#pragma mark - GETTER

- (NSUInteger)getDayCountOfWeek
{
    return 7;
}

- (NSMutableArray<__kindof NSNumber *> *)getWeekdays
{
    NSUInteger firstWeekday = self.firstWeekday;
    
    if (firstWeekday == 0) {
        firstWeekday = 7;
    }
    
    static NSMutableArray *mutableWeekdays = nil;
    mutableWeekdays = [NSMutableArray arrayWithObjects:@(1), @(2), @(3), @(4), @(5), @(6), @(7), nil];
    
    // 获取处于 first weekday 之前的对象范围
    NSRange rangeOfObjectsBeforeFirstWeekday = NSMakeRange(0, [mutableWeekdays indexOfObject:@(firstWeekday)]);
    
    // 获取这些对象
    NSArray *theObjectsBeforeFirstWeekday = [mutableWeekdays subarrayWithRange:rangeOfObjectsBeforeFirstWeekday];
    
    // 移除这些对象
    [mutableWeekdays removeObjectsInRange:rangeOfObjectsBeforeFirstWeekday];
    
    // 将这些对象追加到尾部
    [mutableWeekdays addObjectsFromArray:theObjectsBeforeFirstWeekday];
    
    return mutableWeekdays;
}

- (NSDictionary *)getWeekdaysArabicNumberToChineseDictionary
{
    static NSDictionary *dictionary = nil;
    
    dictionary = @{@"1": @"一",
                   @"2": @"二",
                   @"3": @"三",
                   @"4": @"四",
                   @"5": @"五",
                   @"6": @"六",
                   @"7": @"日"};
    
    return dictionary;
}

- (NSDate *)getDateWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day
{
    NSString *dateDescription = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    static NSDateFormatter *dateFormatter = nil;
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-M-d";
    NSDate *date = [dateFormatter dateFromString:dateDescription];
    return date;
    
}

// 这部分数据应该在该 section 计算完之后保存起来, 当 row 中需要时直接使用
- (NSUInteger)getDaysOfCurrentMonthInSection:(NSInteger)section
{
    // 当月
    NSString *month = [NSString stringWithFormat:@"%@", self.monthArray[section]];
    
    // 当月 当日 date
    NSDate *dateForSection = [self getDateWithYear:self.year month:month day:month];
    
    // 当月天数
    NSUInteger days = [MRCalendar getCalendarRangeOfUnit:NSCalendarUnitDay
                                                  inUnit:NSCalendarUnitMonth
                                                 forDate:dateForSection].length;
    return days;
}

// 这部分数据应该在该 section 计算完之后保存起来, 当 row 中需要时直接使用
- (NSUInteger)getDaysOfLastMonthInSection:(NSInteger)section
{
    // 当前 setcion 中展示的月
    NSString *month = [NSString stringWithFormat:@"%@", self.monthArray[section]];
    
    // 当前 section 中展示的月的 date
    NSDate *dateForSection = [self getDateWithYear:self.year month:month day:month];
    
    // 当前 section 中展示的月的前一个月的 dateComponents
    NSDateComponents *dateComponentsForSection = [MRCalendar getDateComponentsWithDate:dateForSection];
    [dateComponentsForSection setMonth:dateComponentsForSection.month - 1];
    
    // 当前 section 中展示的月的前一个月的 dateComponents 的 date
    // ** 当 month 发生改变, 可能已经跨年 **
    NSDate *lastMonthOfDateforSection = [MRCalendar getDateWithDateComponents:dateComponentsForSection];
    
    // 上月天数
    NSUInteger days = [MRCalendar getCalendarRangeOfUnit:NSCalendarUnitDay
                                                  inUnit:NSCalendarUnitMonth
                                                 forDate:lastMonthOfDateforSection].length;
    // 上月最后一天的 date
    NSDate *lastDayDate = [self getDateWithYear:[NSString stringWithFormat:@"%d", (unsigned)dateComponentsForSection.year]
                                          month:[NSString stringWithFormat:@"%d", (unsigned)dateComponentsForSection.month]
                                            day:[NSString stringWithFormat:@"%d", (unsigned)days]];
    
    // 上月的最后一天的 date 的 dateComponents
    NSDateComponents *dateComponents = [MRCalendar getDateComponentsWithDate:lastDayDate];
    
    // 上月的最后一天的星期 weekday
    NSUInteger componentsWeekday = dateComponents.weekday;
    
    NSUInteger currentRuleWeekday = [[self getWeekdays][componentsWeekday - 1] integerValue];
    
    // 获取 weekday 在当前 weekdays 规则(一周的第一天是星期几)数组中的序号, 如果位于末位, 说明上个月整好以周末结束, 否则, 就增加对应的天数
    
    NSUInteger weekdayIndexOfCurrentRulesWeekdays = [[self getWeekdays] indexOfObject:@(currentRuleWeekday)];
    
    // 非末位, 即非当前规则中一周的最后一天.
    if (weekdayIndexOfCurrentRulesWeekdays != [self getDayCountOfWeek] - 1) {
        
        // 这个 days 就是当月1号所对应的星期几之前的那几天
        return weekdayIndexOfCurrentRulesWeekdays + 1;
        
    } else {
        
        return 0;
        
    }
}

- (NSArray *)getSegmentationArrayWithConsecutiveNumberInArray:(NSArray *)numberArray
{
    NSUInteger count = numberArray.count;
    
    NSUInteger previousValue = 0;
    
    NSMutableArray *larger = [NSMutableArray array];
    
    NSMutableArray *smaller = nil;
    
    for (int idx = 0; idx < count; idx++) {
        
        if (idx == 0) {
            
            smaller = [NSMutableArray array];
            [smaller addObject:numberArray[idx]];
            [larger addObject:smaller];
            
        } else {
            
            // 如果连续
            if ([numberArray[idx] integerValue] - previousValue == 1) {
                
                [smaller addObject:numberArray[idx]];
                
            } else {
                
                smaller = [NSMutableArray array];
                [smaller addObject:numberArray[idx]];
                [larger addObject:smaller];
                
            }
            
        }
        
        previousValue = [numberArray[idx] integerValue];
        
    }
    
    return self.segmentationDayArray = [NSArray arrayWithArray:larger];
}

- (NSDictionary *)getItemCoverViewStyleDictionaryWithSegmentationArray:(NSArray<__kindof NSArray *> *)dayArray
{
    NSMutableDictionary *coverViewStyleDictionary = [NSMutableDictionary dictionary];
    
    [dayArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull segment, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (segment.count == 1) {
            
            coverViewStyleDictionary[segment.firstObject] = MRCalendarItemCoverViewStyleDirectionClose;
            
        } else if (segment.count == 2) {
            
            coverViewStyleDictionary[segment.firstObject] = MRCalendarItemCoverViewStyleDirectionRight;
            
            coverViewStyleDictionary[segment.lastObject] = MRCalendarItemCoverViewStyleDirectionLeft;
            
        } else {
            
            [segment enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (idx == 0) {
                    
                    coverViewStyleDictionary[obj] = MRCalendarItemCoverViewStyleDirectionRight;
                    
                } else if (idx == segment.count - 1) {
                    
                    coverViewStyleDictionary[obj] = MRCalendarItemCoverViewStyleDirectionLeft;
                    
                } else {
                    
                    coverViewStyleDictionary[obj] = MRCalendarItemCoverViewStyleDirectionLeftAndRight;
                    
                }
                
            }];
            
        }
        
    }];
    
    return coverViewStyleDictionary;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat availableCollectionWidth = CGRectGetWidth(self.bounds) - _leftSpacing - _rightSpacing;
    
    CGFloat availableItemFloatWidth = availableCollectionWidth / [self getDayCountOfWeek];
    
    NSUInteger availableItemIntegerWidth = availableCollectionWidth / [self getDayCountOfWeek];
    
    BOOL availableItemWidthIsInteger = availableItemFloatWidth == availableItemIntegerWidth;
    
    if (!availableItemWidthIsInteger) {
        
        CGFloat restWidth = availableCollectionWidth - availableItemIntegerWidth * [self getDayCountOfWeek];
        
        _leftSpacing = _leftSpacing + restWidth / 2.0f;
        
        _rightSpacing = _rightSpacing + restWidth / 2.0f;
        
    }
    
    return CGSizeMake(availableItemIntegerWidth, availableItemIntegerWidth);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(self.topSpacing,
                            self.leftSpacing,
                            self.bottomSpacing,
                            self.rightSpacing);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.minLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), 50.0f);
}

#pragma mark - <UICollectionViewDataSource>

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        MRCalendarMonthItem *monthItem = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Month" forIndexPath:indexPath];
        
        monthItem.year = [NSString stringWithFormat:@"%@年", self.year];
        
        NSString *month = self.monthArray[indexPath.row];
        
        monthItem.month = [NSString stringWithFormat:@"%@月", month];
        
        return monthItem;
        
    } else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.monthArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger number = 0;
    
    // 增加显示星期 "[日, 六]" 的天数
    number += [self getDayCountOfWeek];
    
    // 增加本月天数
    number += [self getDaysOfCurrentMonthInSection:section];
    
    // 增加当月1号对应的星期几之前的天数
    number += [self getDaysOfLastMonthInSection:section];
    
    // 增加本月末尾星期中被下个月占用的天数
    // 暂时先不加
    number += 0;
    
    return number;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MRCalendarItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"Day" forIndexPath:indexPath];
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(MRCalendarItem *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self configWeekIfNeedWithCollectionView:collectionView item:cell indexPath:indexPath];
}

#pragma mark - CONFIG CELL UI

- (void)configWeekIfNeedWithCollectionView:(UICollectionView *)collectionView item:(MRCalendarItem *)item indexPath:(NSIndexPath *)indexPath
{
    item.coverStyle = MRCalendarItemCoverViewStyleNone;
    
    item.itemStyle = MRCalendarItemStyleDefault;
    
    item.title = @"";
    
    NSUInteger daysOfCurrentMonthInSection = [self getDaysOfCurrentMonthInSection:indexPath.section];
    
    NSUInteger daysOfLastMonthInSection = [self getDaysOfLastMonthInSection:indexPath.section];
    
    // [0, 6] is weekday index path
    if (indexPath.row >= 0 && indexPath.row <= 6) {
        
        NSString *weekdayArabicNumber = [NSString stringWithFormat:@"%@", [self getWeekdays][indexPath.row]];
        
        item.title = [self getWeekdaysArabicNumberToChineseDictionary][weekdayArabicNumber];
        
        item.itemStyle = MRCalendarItemStyleWeekday;
        
    // (6, (6 + daysOfLastMonthInSection)] is days of last month index path
    } else if (indexPath.row <= (6 + daysOfLastMonthInSection)) {
        
        // 暂时先不显示具体是几号到几号, 之后有空再计算
        item.title = @"";
        
        item.coverStyle = MRCalendarItemCoverViewStyleNone;
        
    // (daysOfLastMonthInSection, (daysOfLastMonthInSection + daysOfLastMonthInSection)] is days of current month index path
    } else if (indexPath.row <= (6 + daysOfLastMonthInSection + daysOfCurrentMonthInSection)) {
        
        NSUInteger day = indexPath.row - 6 - daysOfLastMonthInSection;
     
        item.title = [NSString stringWithFormat:@"%d", (unsigned)day];
        
        NSString *dayDescription = [NSString stringWithFormat:@"%d", (unsigned)day];
        
        NSString *style = [self.itemCoverViewStyleDictionary objectForKey:dayDescription];
        
        item.coverStyle = style;

    } else {
        
        // 暂时先不显示
        item.title = @"";
        
        item.coverStyle = MRCalendarItemCoverViewStyleNone;
        
    }
}

@end
