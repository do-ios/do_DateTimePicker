//
//  do_DataTimeView.m
//  Do_Test
//
//  Created by yz on 15/6/12.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_DateTimeView.h"

@interface do_DateTimeView()
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)UIDatePicker *timePicker;
@end
@implementation do_DateTimeView

- (instancetype)initDateTimeView
{
    if (self = [super init]) {
//        self.frame = CGRectMake(0, 0, 0, 0);
    }
    return self;
}
- (instancetype)initDateTimeView:(int)type withDate:(NSString *)date withMaxDate:(NSString *)maxDate withMinDate:(NSString *)minDate withTitle:(NSString *)title withLeftBtn:(NSString *)left withRightBtn:(NSString *)right
{
    if (self = [super init]) {
        self.type = type;
        self.title = title;
        self.date = date;
        self.maxDate = maxDate;
        self.minDate = minDate;
        self.button1text = left;
        self.button2text = right;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+ (instancetype) DataTime
{
    return [[self alloc] initDateTimeView];
}
- (void)drawRect:(CGRect)rect
{
    [self setUpDateTimeView:self.type];
    [self setUpButtonView];
    [self setUpTitle];

}
#pragma mark -
#pragma mark 初始化
/**
 *  初始化日期时间
 *
 *  @param type <#type description#>
 */
- (void) setUpDateTimeView:(int)type
{
    switch (type) {
        case 1://日期和时间
        {
            //日期
            UIDatePicker *date = [[UIDatePicker alloc]init];
            date.frame = CGRectMake(0, self.frame.size.height / 3, self.frame.size.width / 2, self.frame.size.height / 2);
            date = [self setDatePicker:date withCurrentDate:self.date withMinDate:self.minDate withMaxDate:self.maxDate];
            date.datePickerMode = UIDatePickerModeDate;
            [self addSubview:date];
            
            //时间
            UIDatePicker *time = [[UIDatePicker alloc]init];
            time.frame = CGRectMake(date.frame.size.width, self.frame.size.height / 3, self.frame.size.width / 2, self.frame.size.height / 2);
            time.datePickerMode = UIDatePickerModeTime;
            [self addSubview:time];
            self.datePicker = date;
            self.timePicker = time;
        }
            break;
        case 2://日期
        {
            UIDatePicker *date = [[UIDatePicker alloc]init];
            date.frame = CGRectMake(0, self.frame.size.height / 3, self.frame.size.width, self.frame.size.height);
            date = [self setDatePicker:date withCurrentDate:self.date withMinDate:self.minDate withMaxDate:self.maxDate];
            date.datePickerMode = UIDatePickerModeDate;
            [self addSubview:date];
            self.datePicker = date;
        }
            break;
        case 3://时间
        {
            UIDatePicker *time = [[UIDatePicker alloc]init];
            time.frame = CGRectMake(0, self.frame.size.height / 3, self.frame.size.width, self.frame.size.height);
            time = [self setDatePicker:time withCurrentDate:self.date withMinDate:self.minDate withMaxDate:self.maxDate];
            time.datePickerMode = UIDatePickerModeTime;
            [self addSubview:time];
            self.timePicker = time;
        }
            break;
    }
}
- (UIDatePicker *)setDatePicker:(UIDatePicker *)datePicker withCurrentDate:(NSString *)date withMinDate:(NSString *)minDate withMaxDate:(NSString *)maxDate
{
    if (self.date.length > 0) {
        double currentDate = [self.date doubleValue];
        datePicker.date = [NSDate dateWithTimeIntervalSince1970:currentDate];
    }
    if (self.minDate > 0) {
        double minDate = [self.minDate doubleValue];
        datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:minDate];
    }
    if (self.maxDate > 0) {
        double maxDate = [self.maxDate doubleValue];
        datePicker.maximumDate = [NSDate dateWithTimeIntervalSince1970:maxDate];
    }
    return datePicker;
}
/**
 *  初始化按钮
 */
- (void)setUpButtonView
{
    //左边按钮
    CGFloat btnWith = 100;
    CGFloat btnHeight = 80;
    CGFloat margin = (self.frame.size.width - btnWith * 2) / 3;
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(margin, self.frame.size.height - 200, btnWith, btnHeight);
    [leftBtn setTitle:self.button1text forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    //右边按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake((btnWith + margin * 2), self.frame.size.height - 200,btnWith, btnHeight);
    [rightBtn setTitle:self.button2text forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
}

/**
 *  初始化标题
 */
- (void)setUpTitle
{
    UILabel *title = [[UILabel alloc]init];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 20, self.frame.size.width, 80);
    [self addSubview:title];
}


- (void) leftBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(leftBtnDidClick)]) {
        [self.delegate leftBtnDidClick];
    }
}

- (void)rightBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(rightBtnDidClick)]) {
        [self.delegate rightBtnDidClick];
    }
}
#pragma mark -
#pragma mark 获得时间
- (long)getTime
{
    if (self.datePicker && self.timePicker) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *timeCompt = [calendar components:(NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:self.timePicker.date];
        NSDateComponents *dateCompt = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:self.datePicker.date];
        dateCompt.hour = timeCompt.hour;
        dateCompt.minute = timeCompt.minute;
        dateCompt.second = timeCompt.second;
        NSDate *date = [calendar dateFromComponents:dateCompt];
        return date.timeIntervalSince1970;
    }
    if (self.datePicker) {
        NSDate *currentDate = self.datePicker.date;
        return currentDate.timeIntervalSince1970;
    }
    if (self.timePicker) {
        return self.timePicker.date.timeIntervalSince1970;
    }
    return 0;
}

@end
