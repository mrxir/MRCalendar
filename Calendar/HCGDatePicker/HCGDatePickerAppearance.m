//
//  HCGDatePickerAppearance.m
//  HcgDatePicker-master
//
//  Created by 黄成钢 on 14/12/2016.
//  Copyright © 2016 chedaoshanqian. All rights reserved.
//

#import "HCGDatePickerAppearance.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define DATE_PICKER_HEIGHT 250.0f
#define TOOLVIEW_HEIGHT 45.0f
#define BACK_HEIGHT TOOLVIEW_HEIGHT + DATE_PICKER_HEIGHT

typedef void(^dateBlock)(NSDate *);

@interface HCGDatePickerAppearance ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) DatePickerMode dataPickerMode;

@property (nonatomic, copy) dateBlock dateBlock;

@property (nonatomic, strong) HCGDatePicker *datePicker;

@end

@implementation HCGDatePickerAppearance

- (instancetype)initWithDatePickerMode:(DatePickerMode)dataPickerMode completeBlock:(void (^)(NSDate *date))completeBlock {
    self = [super init];
    if (self) {
        _dataPickerMode = dataPickerMode;
        [self setupUI];
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _dateBlock = completeBlock;
    }
    return self;
}

- (void)setupUI {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, BACK_HEIGHT)];
    _backView.backgroundColor = [UIColor whiteColor];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, TOOLVIEW_HEIGHT, kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1];
    
    
    _datePicker = [[HCGDatePicker alloc]initWithDatePickerMode:_dataPickerMode MinDate:nil MaxDate:nil];
    _datePicker.frame = CGRectMake(0, TOOLVIEW_HEIGHT, kScreenWidth, DATE_PICKER_HEIGHT);
    
    
    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 0, 100, TOOLVIEW_HEIGHT)];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor colorWithRed:76/255.0f green:123/255.0f blue:252/255.0f alpha:1] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [finishBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, TOOLVIEW_HEIGHT)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:76/255.0f green:123/255.0f blue:252/255.0f alpha:1] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backView addSubview:lineView];
    [self.backView addSubview:_datePicker];
    [self.backView addSubview:finishBtn];
    [self.backView addSubview:cancelBtn];
    [self addSubview:self.backView];
}

- (void)done {
    if (_dateBlock) {
        _dateBlock(_datePicker.date);
    }

    [self hide];
}

- (void)showWithBgAlpha:(CGFloat)alpha {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [UIView animateWithDuration:0.25 animations:^{
        _backView.frame = CGRectMake(0, kScreenHeight - (BACK_HEIGHT), kScreenWidth, BACK_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
    }];
}

-(void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, BACK_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

@end
