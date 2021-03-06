//
//  do_DateTimePicker_SM.m
//  DoExt_API
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_DateTimePicker_SM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doJsonHelper.h"
#import "doIScriptEngine.h"
#import "doIPage.h"
#import <UIKit/UIKit.h>
#import "doTextHelper.h"
#import "doYZAlterView.h"

#define ScreenWidth  280

@interface do_DateTimePicker_SM()<UIAlertViewDelegate,doYZAlterViewDelegate>
@property (nonatomic,strong) UIDatePicker *tempDateView;
@property (nonatomic,strong) UIDatePicker *tempTimeView;
@property (nonatomic,assign) int dateType;
@property (nonatomic,weak) id<doIScriptEngine> scritEngine;
@property (nonatomic,strong) NSString *callbackName;
@property (nonatomic,copy) NSString *currentDate;
@property (nonatomic,strong) UIView *tempView;
@property (nonatomic,strong) UIAlertView *tempAlView;
@property (nonatomic,strong) UILabel *weekLabel;
@property (nonatomic, strong) NSDate *dateForType2AndDataAssign; // type = 2 ,show 方法data赋值时辅助对象
@end
@implementation do_DateTimePicker_SM

#pragma mark - private method

// 后面用到了NSCanlander , 系统自动加了8个时区, 前面所有的准备时间转化工作都别加时区了, 别动了,看不懂就算了
- (NSDate*)getCurrentDate {
//    NSDate *date = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return [NSDate date];
}

- (NSDate*)getDateWithFormatterString:(NSString*)dateString {
//    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = timeZone;
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";// hour大写 表示24小时制
    return [formatter dateFromString:dateString];
}

/// show方法data参数是否赋值
- (BOOL)isDataParamAssigned {
    if ([self.currentDate isEqualToString:[NSString stringWithFormat:@"%f",[[self getCurrentDate] timeIntervalSince1970] * 1000]]) {
        return false;
    }else {
        return true;
    }
}
#pragma mark - 方法
#pragma mark - 同步异步方法的实现
//同步
//异步
- (void)show:(NSArray *)parms
{

    //异步耗时操作，但是不需要启动线程，框架会自动加载一个后台线程处理这个函数
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //参数字典_dictParas
    _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    
    _callbackName = [parms objectAtIndex:2];
    //回调函数名_callbackName

    int type = [doJsonHelper GetOneInteger:_dictParas :@"type" :1];
    self.dateType = type;
    NSTimeInterval curtimeSince1970 = [[self getCurrentDate] timeIntervalSince1970] * 1000;
    // maxDate 2099
    // minDate 1900
    NSString *date2099String = @"2099-12-31 23:59:59";
    NSString *date1900String = @"1970-01-01 00:00:00";

    
    NSDate *date2099 = [self getDateWithFormatterString:date2099String];
    NSDate *date1900 = [self getDateWithFormatterString:date1900String];
    
    NSTimeInterval time2099Sine1970 = date2099.timeIntervalSince1970 * 1000;
    NSTimeInterval time1900Sine1970 = date1900.timeIntervalSince1970 * 1000;
    
    NSString *date = [doJsonHelper GetOneText:_dictParas :@"data" :[NSString stringWithFormat:@"%f",curtimeSince1970]];
    self.currentDate = date;
    NSString *maxDate = [doJsonHelper GetOneText:_dictParas :@"maxDate" :[NSString stringWithFormat:@"%f",time2099Sine1970]];
    NSString *minDate = [doJsonHelper GetOneText:_dictParas :@"minDate" :[NSString stringWithFormat:@"%f",time1900Sine1970]];
    NSString *title = [doJsonHelper GetOneText:_dictParas :@"title" :@""];
    title = [self getTitle:title withType:type];
    NSArray *buttons = [doJsonHelper GetOneArray:_dictParas :@"buttons"];
    dispatch_async(dispatch_get_main_queue(), ^{
        doYZAlterView *alterView = [[doYZAlterView alloc]initWithTitle:title withButtons:buttons withType:type];
        alterView.type = type;
        alterView.buttonsCount = (int)[buttons count];
        alterView.delegate = self;
        alterView.contentView = [self getAlterView:type withMaxDate:maxDate withMinDate:minDate];
        [alterView show];
    });
}
- (UIAlertView *) UIActionSheetShow:(NSArray *)btns withAlterView:(UIAlertView *)alView
{
    if (btns.count == 0) {
        [alView addButtonWithTitle:@"确定"];
        [alView addButtonWithTitle:@"取消"];
        return alView;
    }
    for (NSString *btn in btns) {
        [alView addButtonWithTitle:btn];
    }
    return alView;
}

//0表示日期及时间，1表示只有日期，2表示只有时间，3表示日期、星期及时间
- (NSString *)getTitle:(NSString *)title withType:(int)type
{
    if (title.length > 0) {
        return title;
    }
    switch (type) {
        case 0:
            title = @"日期时间选择";
            break;
        case 1:
            title = @"日期选择";
            break;
        case 2:
            title = @"时间选择";
            break;
        case 3:
            title = @"日期时间选择";
            break;
    }
    return title;
}
- (UIView *) getAlterView:(int) type withMaxDate:(NSString *)maxDate withMinDate:(NSString *)minDate
{
    UIView *supView;
    switch (type) {
        case 0://日期和时间
        {
            supView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 442)];
            UIDatePicker *datePicker = [self createDateOrTime:0 withDate:self.currentDate withMinDate:minDate withMaxDate:maxDate];
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            datePicker.frame = CGRectMake(0, 30, 280, 216);
            datePicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            UIDatePicker *timePicker = [self createDateOrTime:1 withDate:self.currentDate withMinDate:minDate withMaxDate:maxDate];
            [timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
            timePicker.frame = CGRectMake(0, 236, 280, 216);
            timePicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [supView addSubview:datePicker];
            [supView addSubview:timePicker];
        }
            break;
        case 1://日期
        {
            supView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 216)];
            UIDatePicker *datePicker = [self createDateOrTime:0 withDate:self.currentDate withMinDate:minDate withMaxDate:maxDate];
            datePicker.frame = CGRectMake(0, 30, 280, 216);
            datePicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

            [supView addSubview:datePicker];
        }
            break;
        case 2://时间
        {
            NSDate *currentDate = [self getCurrentDate];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
            NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            
            NSDateComponents *Curcomps  = [calendar components:unitFlags fromDate:currentDate];
            double date0 = [[doTextHelper Instance]StrToLong:self.currentDate :0];
            double date1 = [[doTextHelper Instance]StrToLong:maxDate :0];
            double date2 = [[doTextHelper Instance]StrToLong:minDate :0];
            NSDate *valueDate = [NSDate dateWithTimeIntervalSince1970:(date0 / 1000)];
            self.dateForType2AndDataAssign = valueDate;
            NSDate *maDate = [NSDate dateWithTimeIntervalSince1970:(date1 / 1000)];
            NSDate *miDate = [NSDate dateWithTimeIntervalSince1970:(date2 / 1000)];
            NSDateComponents *comps0 = [calendar components:unitFlags fromDate:valueDate];
            NSDateComponents *comps1 = [calendar components:unitFlags fromDate:maDate];
            NSDateComponents *comps2  = [calendar components:unitFlags fromDate:miDate];
            [comps0 setYear:Curcomps.year];
            [comps0 setMonth:Curcomps.month];
            [comps0 setDay:Curcomps.day];
            
            [comps1 setYear:Curcomps.year];
            [comps1 setMonth:Curcomps.month];
            [comps1 setDay:Curcomps.day];
            
            [comps2 setYear:Curcomps.year];
            [comps2 setMonth:Curcomps.month];
            [comps2 setDay:Curcomps.day];
            
            valueDate = [calendar dateFromComponents:comps0];
            maDate = [calendar dateFromComponents:comps1];
            miDate = [calendar dateFromComponents:comps2];
            
            self.currentDate = [NSString stringWithFormat:@"%f",valueDate.timeIntervalSince1970 * 1000];
            minDate = [NSString stringWithFormat:@"%f",miDate.timeIntervalSince1970 * 1000];
            maxDate = [NSString stringWithFormat:@"%f",maDate.timeIntervalSince1970 * 1000];
            supView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 216)];
            UIDatePicker *timePicker = [self createDateOrTime:1 withDate:self.currentDate withMinDate:minDate withMaxDate:maxDate];
            timePicker.frame = CGRectMake(0, 30, 280, 216);
            timePicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

            [supView addSubview:timePicker];
        }
            break;
            case 3://日期时间及星期几
        {
            supView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, ScreenWidth, 442)];
            UIDatePicker *datePicker = [self createDateOrTime:0 withDate:self.currentDate withMinDate:minDate withMaxDate:maxDate];;
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            datePicker.frame = CGRectMake(0, 30, 280, 216);
            datePicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            
            UILabel *weekLabel = [[UILabel alloc]init];
            weekLabel.frame = CGRectMake(0, 236, ScreenWidth, 40);
            weekLabel.text = [self getWeekWith:datePicker];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            [supView addSubview:weekLabel];
            self.weekLabel = weekLabel;
            UIDatePicker *timePicker = [self createDateOrTime:1 withDate:self.currentDate withMinDate:minDate withMaxDate:maxDate];
            [timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
            timePicker.frame = CGRectMake(0, 262, 280, 216);
            timePicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [supView addSubview:datePicker];
            [supView addSubview:timePicker];
        }
            break;
    }
    supView.clipsToBounds = YES;
    return supView;
}

- (NSString *)getWeekWith:(UIDatePicker *)dataPicker
{

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [dataPicker.calendar components:unitFlags fromDate:dataPicker.date];
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    return [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:[comps weekday] - 1]];
}
#pragma - mark -
#pragma - mark 日期时间联动
- (void)dateChanged:(UIDatePicker *)sender
{
    [self.tempTimeView setDate:sender.date animated:YES];
    self.weekLabel.text = [self getWeekWith:sender];
}

- (void)timeChanged:(UIDatePicker *)sender
{
    [self.tempDateView setDate:sender.date animated:YES];
}
#pragma - mark -
#pragma - mark 创建日期或时间选择器
- (UIDatePicker *)createDateOrTime:(int)type withDate:(NSString *)date withMinDate:(NSString *)minDate withMaxDate:(NSString *)maxDate
{
//    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 216)];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    if (type == 0) {
        datePicker.datePickerMode = UIDatePickerModeDate;
        self.tempDateView = datePicker;
        
    }
    else
    {
        datePicker.datePickerMode = UIDatePickerModeTime;
        self.tempTimeView = datePicker;
    }
    if (self.dateType != 2) {
        double max;
        double min;
        max = [[doTextHelper alloc]StrToLong:maxDate :0];
        min = [[doTextHelper alloc]StrToLong:minDate :0];
        if (max < min) {
            datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:(min / 1000)];
            datePicker.maximumDate = [NSDate dateWithTimeIntervalSince1970:(4102329600)];
            if (date.length == 0) {
                datePicker.date = [NSDate date];
                return datePicker;
            }
            double currentDate = [[doTextHelper alloc]StrToLong:date :0];
            
            datePicker.date = [NSDate dateWithTimeIntervalSince1970:(currentDate / 1000)];
            return datePicker;
        }
        if (date.length > 0) {
            
            double currentDate = [[doTextHelper alloc]StrToLong:date :0];
            datePicker.date = [NSDate dateWithTimeIntervalSince1970:(currentDate / 1000)];
        }
        else
        {
            datePicker.date = [NSDate date];
        }
        if (minDate.length > 0) {
            double min = [[doTextHelper alloc]StrToLong:minDate :0];
            datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:(min / 1000)];
        }
        else
        {
            datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
        }
        if (maxDate.length > 0) {
            double max = [[doTextHelper alloc]StrToLong:maxDate :0];
            datePicker.maximumDate = [NSDate dateWithTimeIntervalSince1970:(max / 1000)];
        }
        else
        {
            datePicker.maximumDate = [NSDate dateWithTimeIntervalSince1970:(4102329600)];
        }
    }else {
        if ([self isDataParamAssigned]) {
            [datePicker setDate:self.dateForType2AndDataAssign];
        }
    }
    
    return datePicker;
}
#pragma mark -
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [alertView removeFromSuperview];
    });
    NSMutableDictionary *resultNode = [NSMutableDictionary dictionary];
    long long selectTime = 0.0;
    NSString *flag = [NSString stringWithFormat:@"%ld", (long)buttonIndex];
    if (self.dateType == 2) {
        selectTime = self.tempTimeView.date.timeIntervalSince1970 * 1000;
    }
    else
    {
        selectTime = self.tempDateView.date.timeIntervalSince1970 * 1000;
    }
    [resultNode setValue:[NSString stringWithFormat:@"%lld",selectTime]forKey:@"time"];
    [resultNode setValue:flag forKey:@"flag"];
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
    [_invokeResult SetResultNode:resultNode];
    [_scritEngine Callback:_callbackName :_invokeResult];
}

@end
