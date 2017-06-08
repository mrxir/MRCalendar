//
//  ViewController.m
//  Calendar
//
//  Created by 🍉 on 2017/6/1.
//  Copyright © 2017年 🍉. All rights reserved.
//

#import "ViewController.h"

#import "CollectionViewCell.h"

#import "HCGDatePickerAppearance.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *uploadRecord;

@property (nonatomic, copy) NSString *currentYear;

@property (nonatomic, strong) NSDictionary *currentYearUploadRecord;

@end

@implementation ViewController

- (void)setCurrentYear:(NSString *)currentYear
{
    _currentYear = currentYear;
    
    self.title = [NSString stringWithFormat:@"公元 %@ 年", _currentYear];
}

- (void)didClickDatePickerItem:(UIBarButtonItem *)item
{
    static NSDateFormatter *yearDateFormatter = nil;
    static NSString *year = nil;
    if (!yearDateFormatter) {
        yearDateFormatter = [[NSDateFormatter alloc] init];
        yearDateFormatter.dateFormat = @"yyyy";
    }
    
    HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc] initWithDatePickerMode:DatePickerYearMode completeBlock:^(NSDate *date) {
        year = [yearDateFormatter stringFromDate:date];
        
        self.currentYear = year;
        
        [self filterCurrentYearUploadRecordWith:self.currentYear];
        
        [self.collectionView reloadData];
        
        if (self.collectionView.numberOfSections != 0) {
            
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            
        }
        
       
        
        
    }];
    [picker showWithBgAlpha:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *dateItem = [[UIBarButtonItem alloc] initWithTitle:@"年份"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(didClickDatePickerItem:)];
    self.navigationItem.rightBarButtonItem = dateItem;
    
    CGFloat cellHeight = ceilf(CGRectGetWidth([UIScreen mainScreen].bounds) / 7.0 * 8.0);
    
    UICollectionViewFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), cellHeight);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.collectionView.contentInset = UIEdgeInsetsMake(layout.sectionInset.top,
                                                        layout.sectionInset.left,
                                                        - layout.sectionInset.bottom,
                                                        layout.sectionInset.right);
    [self.collectionView setCollectionViewLayout:layout];

    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UploadRecord" ofType:@"json"]];
    NSDictionary *dictionary = nil;
    
    @try {
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    } @catch (NSException *exception) {
        NSLog(@" | * [ERROR] %@", exception);
    }
    
    self.uploadRecord = dictionary[@"data"];
    
    self.currentYear = @"2048";
    
    [self filterCurrentYearUploadRecordWith:self.currentYear];
    
    [self.collectionView reloadData];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterCurrentYearUploadRecordWith:(NSString *)year
{
    self.currentYear = year;
    
    __block NSDictionary *record = nil;
    
    // 从数据中找出 current year
    [self.uploadRecord enumerateObjectsUsingBlock:^(__kindof NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj[@"year"] isEqualToString:year]) {
            
            record = obj;
            *stop = YES;
            
        }
        
    }];
    
    self.currentYearUploadRecord = record;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.currentYearUploadRecord[@"months"] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.currentYear = self.currentYear;
    
    NSDictionary *dictionaryForSection = self.currentYearUploadRecord[@"months"][indexPath.section];
    
    cell.currentMonthUploadRecord = dictionaryForSection;
    
    [cell prepareDisplay];
    
    return cell;
}

@end
