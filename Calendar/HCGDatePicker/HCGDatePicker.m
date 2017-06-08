//
//  HCGDatePicker.m
//  HcgDatePicker-master
//
//  Created by 黄成钢 on 14/12/2016.
//  Copyright © 2016 chedaoshanqian. All rights reserved.
//

#import "HCGDatePicker.h"

// Identifiers of components
#define DAY ( 2 )
#define MONTH ( 1 )
#define YEAR ( 0 )
#define minTimeInterval 631152000


// Identifies for component views
#define LABEL_TAG 43

@interface HCGDatePicker ()

@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;
@property (nonatomic, strong) NSArray *days;

@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;
@property (nonatomic, assign) NSInteger numberOfComponent;
@property (nonatomic, assign) DatePickerMode datePickerMode;

@property (nonatomic, strong) NSDateFormatter *formatter;


@end

@implementation HCGDatePicker


#pragma mark - Properties

-(void)setMonthFont:(UIFont *)monthFont
{
    if (monthFont)
    {
        _monthFont = monthFont;
    }
}

-(void)setMonthSelectedFont:(UIFont *)monthSelectedFont
{
    if (monthSelectedFont)
    {
        _monthSelectedFont = monthSelectedFont;
    }
}

-(void)setYearFont:(UIFont *)yearFont
{
    if (yearFont)
    {
        _yearFont = yearFont;
    }
}

-(void)setYearSelectedFont:(UIFont *)yearSelectedFont
{
    if (yearSelectedFont)
    {
        _yearSelectedFont = yearSelectedFont;
    }
}

#pragma mark - Init

-(instancetype)initWithDatePickerMode:(DatePickerMode)datePickerMode MinDate:(NSDate *)minDate MaxDate:(NSDate *)maxDate
{
    if (self = [super init])
    {
        self.numberOfComponent = datePickerMode;
        self.datePickerMode = datePickerMode;
        
        if (!minDate) {
            NSString* string = @"20140101";
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [inputFormatter setDateFormat:@"yyyyMMdd"];
            NSDate* inputDate = [inputFormatter dateFromString:string];
            
            [self setMinDate:inputDate];
        }else
        {
            [self setMinDate:minDate];
        }
        
        if (!maxDate) {
            NSDate * date = [NSDate date];
            [self setMaxDate:date];
        }else
        {
            [self setMaxDate:maxDate];
        }
        
        
        
        [self loadDefaultsParameters];
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadDefaultsParameters];
}

#pragma mark - Open methods

-(NSDate *)date
{
    
    
    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR])];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSDate *date;
    
    if (self.datePickerMode == DatePickerYearMode) {
        [formatter setDateFormat:@"yyyy年"];
        date = [formatter dateFromString:[NSString stringWithFormat:@"%@", year]];
        
    } else
    {
        NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH])];
        NSInteger dayCount = self.days.count;
        NSString *day = @"1日";
        if (dayCount != 0 && self.datePickerMode == DatePickerDateMode) {
            day = [self.days objectAtIndex:([self selectedRowInComponent:DAY]) % dayCount];
        }
        if (self.datePickerMode == DatePickerYearMonthMode) {
            [formatter setDateFormat:@"yyyy年M月"];
            date = [formatter dateFromString:[NSString stringWithFormat:@"%@%@", year, month]];
            
        } else if(self.datePickerMode == DatePickerDateMode)
        {
            [formatter setDateFormat:@"yyyy年M月d日"];
            date = [formatter dateFromString:[NSString stringWithFormat:@"%@%@%@", year, month, day]];
            if (!date) {
                [formatter setDateFormat:@"yyyy年M月"];
                date = [formatter dateFromString:[NSString stringWithFormat:@"%@%@", year, month]];
            }
        }
    }
    
    return date;
}



-(NSDate *)monthDate
{
    NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH])];
    
    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR])];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年M月"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@%@", year, month]];
    
    return date;
}

-(NSDate *)yearDate
{
    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR])];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@", year]];
    
    return date;
}

- (void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear
{
    self.minYear = minYear;
    
    
    if (maxYear > minYear)
    {
        self.maxYear = maxYear;
    }
    else
    {
        self.maxYear = 2099;
    }
    
    self.years = [self nameOfYears];
    self.todayIndexPath = [self todayPath];
}


#pragma mark - UIPickerViewDelegate

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

-(UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    BOOL selected = NO;
    if(component == MONTH)
    {
        NSInteger monthCount = self.months.count;
        NSString *monthName = [self.months objectAtIndex:(row % monthCount)];
        NSString *currentMonthName = [self currentMonthName];
        if([monthName isEqualToString:currentMonthName] == YES)
        {
            selected = YES;
        }
    }
    else if(component == YEAR)
    {
        NSInteger yearCount = self.years.count;
        NSString *yearName = [self.years objectAtIndex:(row % yearCount)];
        NSString *currenrYearName  = [self currentYearName];
        if([yearName isEqualToString:currenrYearName] == YES)
        {
            selected = YES;
        }
    }
    else if(component == DAY)
    {
        NSInteger dayCount = self.days.count;
        NSString *dayName = [self.days objectAtIndex:(row % dayCount)];
        NSString *currenrDayName  = [self currentDayName];
        if([dayName isEqualToString:currenrDayName] == YES)
        {
            selected = YES;
        }
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent:component];
    }
    
    returnView.font = selected ? [self selectedFontForComponent:component] : [self fontForComponent:component];
    returnView.textColor = selected ? [self selectedColorForComponent:component] : [self colorForComponent:component];
    
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.rowHeight;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _numberOfComponent;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        return [self bigRowMonthCount];
        
    }else if (component == YEAR) {
        return [self bigRowYearCount];
    }else if (component == DAY) {
        return [self bigRowDaysCount];
    }
    return 0;
}

#pragma mark - Util

-(NSInteger)bigRowMonthCount
{
    return self.months.count;
}

-(NSInteger)bigRowYearCount
{
    return self.years.count;
}

-(NSInteger)bigRowDaysCount
{
    return self.days.count;
}

-(CGFloat)componentWidth
{
    return self.bounds.size.width / _numberOfComponent;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        return [self.months objectAtIndex:(row )];
    } else if(component == YEAR) {
        return [self.years objectAtIndex:(row )];
    } else if (component == DAY) {
        NSInteger DayCount = self.days.count;
        return [self.days objectAtIndex:(row % DayCount)];
    }
    return @"";
}

-(UILabel *)labelForComponent:(NSInteger)component
{
    CGRect frame = CGRectMake(0, 0, [self componentWidth], self.rowHeight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;    // UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    
    label.tag = LABEL_TAG;
    
    return label;
}

-(NSArray *)nameOfMaxDays
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"d"];
    NSInteger DayMax = [formatter stringFromDate:self.maxDate].integerValue;
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 1; i <= DayMax; i ++) {
        NSString *day = [NSString stringWithFormat:@"%d日",i];
        [tempArr addObject:day];
    }
    return tempArr;
}

-(NSArray *)nameOfMinDays
{
    [self.formatter setDateFormat:@"d"];
    
    NSUInteger numberOfDaysInMonth = [self daysCountWithSelDate];
    NSInteger DayMin = [self.formatter stringFromDate:self.minDate].integerValue;
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = DayMin ; i <= numberOfDaysInMonth  ; i ++) {
        NSString *day = [NSString stringWithFormat:@"%ld日",(long)i];
        [tempArr addObject:day];
    }
    return tempArr;
}

-(NSArray *)nameOfMinMaxDays
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"d"];
    NSInteger DayMax = [formatter stringFromDate:self.maxDate].integerValue;
    
    NSInteger DayMin = [formatter stringFromDate:self.minDate].integerValue;
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = DayMin; i <= DayMax; i ++) {
        NSString *day = [NSString stringWithFormat:@"%ld日",(long)i];
        [tempArr addObject:day];
    }
    return tempArr;
}

-(NSArray *)nameOfDays
{
    NSUInteger numberOfDaysInMonth = [self daysCountWithSelDate];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 1; i < numberOfDaysInMonth +1 ; i ++) {
        NSString *day = [NSString stringWithFormat:@"%d日",i];
        [tempArr addObject:day];
    }
    return tempArr;
}

-(NSInteger)daysCountWithSelDate {
    self.calendar = [NSCalendar currentCalendar];
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self monthDate]];
    return range.length;
}


-(NSArray *)nameOfMinMonths {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"M"];
    NSInteger monthMin = [formatter stringFromDate:self.minDate].integerValue;
    NSMutableArray *months = [NSMutableArray array];
    
    for(NSInteger month = monthMin; month <= 12; month++)
    {
        NSString *monthStr = [NSString stringWithFormat:@"%li月", (long)month];
        [months addObject:monthStr];
    }
    return months;
}

-(NSArray *)nameOfMaxMonths {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"M"];
    NSInteger monthMax = [formatter stringFromDate:self.maxDate].integerValue;
    
    NSMutableArray *months = [NSMutableArray array];
    
    for(NSInteger month = 1; month <= monthMax; month++)
    {
        NSString *monthStr = [NSString stringWithFormat:@"%li月", (long)month];
        [months addObject:monthStr];
    }
    return months;
}

-(NSArray *)nameOfMaxAndMinMonths {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"M"];
    NSInteger monthMin = [formatter stringFromDate:self.minDate].integerValue;
    NSInteger monthMax = [formatter stringFromDate:self.maxDate].integerValue;
    
    NSMutableArray *months = [NSMutableArray array];
    
    for(NSInteger month = monthMin; month <= monthMax; month++)
    {
        NSString *monthStr = [NSString stringWithFormat:@"%li月", (long)month];
        [months addObject:monthStr];
    }
    return months;
}

-(NSArray *)nameOfMonths
{
    
    return @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
}

-(NSArray *)nameOfYears
{
    NSMutableArray *years = [NSMutableArray array];
    
    for(NSInteger year = self.minYear; year <= self.maxYear; year++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%li年", (long)year];
        [years addObject:yearStr];
    }
    return years;
}


-(NSIndexPath *)todayPath // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self currentMonthName];
    NSString *year  = [self currentYearName];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"M月"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentDayName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"d日"];
    return [formatter stringFromDate:[NSDate date]];
}


- (UIColor *)selectedColorForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthSelectedTextColor;
    }
    return self.yearSelectedTextColor;
}

- (UIColor *)colorForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthTextColor;
    }
    return self.yearTextColor;
}

- (UIFont *)selectedFontForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthSelectedFont;
    }
    return self.yearSelectedFont;
}

- (UIFont *)fontForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthFont;
    }
    return self.yearFont;
}

-(void)loadDefaultsParameters
{
    self.rowHeight = 40;
    self.years = [self nameOfYears];
    self.months = [self nameOfMonths];
    self.todayIndexPath = [self todayPath];
    
    self.delegate = self;
    self.dataSource = self;
    if (self.datePickerMode == DatePickerYearMode) {
        
    }else{
         self.days = [self nameOfDays];
    }
   
    [self selectDate:self.minDate];
        
    self.monthSelectedTextColor = [UIColor blackColor];
    self.monthTextColor = [UIColor blackColor];
    
    self.yearSelectedTextColor = [UIColor blackColor];
    self.yearTextColor = [UIColor blackColor];
    
    self.monthSelectedFont = [UIFont systemFontOfSize:28];
    self.monthFont = [UIFont systemFontOfSize:28];
    
    self.yearSelectedFont = [UIFont systemFontOfSize:28];
    self.yearFont = [UIFont systemFontOfSize:28];
}




- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        if (self.datePickerMode == DatePickerYearMode) {
            [pickerView reloadComponent:0];
        }else{
            if ([self selectedRowInComponent:YEAR] == 0 && self.years.count != 1) {
                self.months = [self nameOfMinMonths];
            } else if ([self selectedRowInComponent:YEAR] == self.years.count - 1 && self.years.count != 1) {
                self.months = [self nameOfMaxMonths];
            }else if (self.years.count == 1){
                self.months = [self nameOfMaxAndMinMonths];
            } else {
                self.months = [self nameOfMonths];
                
            }
            [pickerView reloadComponent:1];
            if (self.datePickerMode == DatePickerDateMode) {
                [pickerView reloadComponent:DAY];
            }
        }
        
    }
    
    
    if (self.datePickerMode == DatePickerDateMode) {
        
        NSInteger currert =[pickerView selectedRowInComponent:DAY] + 1;
        if (currert > [self daysCountWithSelDate] && self.datePickerMode == DatePickerDateMode) {
            [pickerView selectRow:[self daysCountWithSelDate] inComponent:DAY animated:NO];
        }
        if (component == 0 ||component == 1) {
            if(( self.years.count  == 1) && self.months.count == 1) {
                self.days = [self nameOfMinMaxDays];
            } else if (([self selectedRowInComponent:YEAR] == self.years.count - 1) && [self selectedRowInComponent:MONTH] == self.months.count - 1 ) {
                self.days = [self nameOfMaxDays];
            } else if (([self selectedRowInComponent:YEAR] == 0 ) && [self selectedRowInComponent:MONTH] == 0 ) {
                //&& self.months.count != 1
                self.days = [self nameOfMinDays];
            } else {
                self.days = [self nameOfDays];
                
            }
            [pickerView reloadComponent:2];
        }
    }
    
    
    if ([self.dvDelegate respondsToSelector:@selector(datePicker:didSelectedDate:)]) {
        [self.dvDelegate datePicker:self didSelectedDate:[self date]];
    }
    
}

- (void)selectDate:(NSDate *)date{
    NSIndexPath *selectIndexPath = [self selectPathWithDate:date];
    
    [self selectRow: selectIndexPath.section
        inComponent: YEAR
           animated: YES];
    [self pickerView:self didSelectRow:selectIndexPath.row inComponent:YEAR];
    
    selectIndexPath = [self selectPathWithDate:date];
    
    
    
    [self pickerView:self didSelectRow:selectIndexPath.row inComponent:MONTH];
    if (self.datePickerMode == DatePickerDateMode) {
        CGFloat day = [self selectDayIndexWithDate:date];
        [self selectRow:day inComponent:DAY animated:YES];
        [self pickerView:self didSelectRow:day inComponent:DAY];
    }
    
    if (self.datePickerMode == DatePickerYearMonthMode) {
        [self selectRow: selectIndexPath.row inComponent: MONTH animated: YES];
    }
    
}

- (void) selectRow:(NSDate *)date {
    NSIndexPath *selectIndexPath = [self selectPathWithDate:date];
    [self selectRow: selectIndexPath.row
        inComponent: MONTH
           animated: YES];
    
    if (self.datePickerMode == DatePickerDateMode) {
        CGFloat day = [self selectDayIndexWithDate:date];
        [self selectRow:day inComponent:DAY animated:YES];
    }
    
    if (self.datePickerMode == DatePickerYearMonthMode) {
        [self selectRow: selectIndexPath.section inComponent: YEAR animated: YES];
    }
}


-(NSString *)selectMonthName:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"M月"];
    return [formatter stringFromDate:date];
}

-(NSString *)selectYearName:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年"];
    return [formatter stringFromDate:date];
}

-(NSString *)selectDayName:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"d日"];
    return [formatter stringFromDate:date];
}


-(NSIndexPath *)selectPathWithDate:(NSDate *)date // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self selectMonthName:date];
    NSString *year  = [self selectYearName:date];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            //            row = row + [self bigRowMonthCount] / 2;
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            //            section = section + [self bigRowYearCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

-(CGFloat)selectDayIndexWithDate:(NSDate *)date {// row - month ; section - year
    CGFloat index = 0.f;
    NSString *Day = [self selectDayName:date];
    for (NSString *cellDay in self.days)
    {
        if([cellDay isEqualToString:Day])
        {
            index = [self.days indexOfObject:cellDay];
            //            index = index + [self bigRowDaysCount] / 2;
            break;
        }
    }
    
    return index;
}


- (void)setMinDate:(NSDate *)minDate{
    _minDate = minDate;
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *minComps = [self.calendar components:unitFlags fromDate:minDate];
    self.minYear = [minComps year];//获取年对应的长整形字符串
}

- (void)setMaxDate:(NSDate *)maxDate{
    _maxDate = maxDate;
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *maxComps = [self.calendar components:unitFlags fromDate:maxDate];
    
    self.maxYear = [maxComps year];//获取年对应的长整形字符串
}

-(NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
        
    }
    return _calendar;
}

-(NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setTimeZone:[NSTimeZone systemTimeZone]];
    }
    return _formatter;
}

- (NSDate *)extractDayDate:(NSDate *)date {
    //get seconds since 1970
    NSTimeInterval interval = [date timeIntervalSince1970] + 8 * 60 * 60;
    int daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;
    
    return [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
}



@end
