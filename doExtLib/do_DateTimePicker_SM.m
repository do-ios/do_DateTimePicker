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

@interface do_DateTimePicker_SM()<UIAlertViewDelegate,doYZAlterViewDelegate>
@property (nonatomic,strong) UIDatePicker *tempDateView;
@property (nonatomic,strong) UIDatePicker *tempTimeView;
@property (nonatomic,assign) int dateType;
@property (nonatomic,weak) id<doIScriptEngine> scritEngine;
@property (nonatomic,strong) NSString *callbackName;
@property (nonatomic,copy) NSString *currentDate;
@property (nonatomic,strong) UIView *tempView;
@property (nonatomic,strong) UIAlertView *tempAlView;
@end
@implementation do_DateTimePicker_SM
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
    NSString *date = [doJsonHelper GetOneText:_dictParas :@"data" :@""];
    self.currentDate = date;
    NSString *maxDate = [doJsonHelper GetOneText:_dictParas :@"maxDate" :@""];
    NSString *minDate = [doJsonHelper GetOneText:_dictParas :@"minDate" :@""];
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
//        UIAlertView *alView = [[UIAlertView alloc]init];
//        alView.delegate = self;
//        alView.title = title;
//        alView = [self UIActionSheetShow:buttons withAlterView:alView];
//        UIView *suView = [self getAlterView:type withMaxDate:maxDate withMinDate:minDate];
//        suView.backgroundColor = [UIColor whiteColor];
//        id<doIPage>pageModel = _scritEngine.CurrentPage;
//        UIViewController *currentVC = (UIViewController *)pageModel.PageView;
//        [currentVC.view addSubview:suView];
//        [alView setValue:suView forKey:@"accessoryView"];
//        [alView show];
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
/**
 *  获得title
 *
 *  @param title <#title description#>
 *  @param type  <#type description#>
 *
 *  @return <#return value description#>
 */
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
    }
    return title;
}
- (UIView *) getAlterView:(int) type withMaxDate:(NSString *)maxDate withMinDate:(NSString *)minDate
{
    UIView *supView;
    switch (type) {
        case 0://日期和时间
        {
            supView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
            UIDatePicker *datePicker = [self createDateOrTime:0 withDate:self.currentDate withMinDate:minDate withMaxDate:maxDate];;
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            datePicker.frame = CGRectMake(0, 10, 320, 216);
            UIDatePicker *timePicker = [self createDateOrTime:1 withDate:self.currentDate withMinDate:minDate withMaxDate:maxDate];
            [timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
            timePicker.frame = CGRectMake(0, 216, 320, 216);
            [supView addSubview:datePicker];
            [supView addSubview:timePicker];
        }
            break;
        case 1://日期
        {
            supView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
            UIDatePicker *datePicker = [self createDateOrTime:0 withDate:self.currentDate withMinDate:minDate withMaxDate:maxDate];
            [supView addSubview:datePicker];
        }
            break;
        case 2://时间
        {
            supView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
            UIDatePicker *timePicker = [self createDateOrTime:1 withDate:self.currentDate withMinDate:minDate withMaxDate:maxDate];;
            [supView addSubview:timePicker];
        }
            break;
    }
//    supView.backgroundColor = [UIColor greenColor];
    return supView;
}

- (void)dateChanged:(UIDatePicker *)sender
{
    [self.tempTimeView setDate:sender.date animated:YES];
}

- (void)timeChanged:(UIDatePicker *)sender
{
    [self.tempDateView setDate:sender.date animated:YES];
}

- (long)getLongDateTime
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *timeCompt = [calendar components:(NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:self.tempDateView.date];
    NSDateComponents *dateCompt = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:self.tempTimeView.date];
    dateCompt.hour = timeCompt.hour;
    dateCompt.minute = timeCompt.minute;
    dateCompt.second = timeCompt.second;
    NSDate *date = [calendar dateFromComponents:dateCompt];
    return date.timeIntervalSince1970;
}

- (UIDatePicker *)createDateOrTime:(int)type withDate:(NSString *)date withMinDate:(NSString *)minDate withMaxDate:(NSString *)maxDate
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 10, 320, 216)];
    if (type == 0) {
        datePicker.datePickerMode = UIDatePickerModeDate;
        self.tempDateView = datePicker;

    }
    else
    {
        datePicker.datePickerMode = UIDatePickerModeTime;
        self.tempTimeView = datePicker;
    }
    if (date.length > 0) {
        
        double currentDate = [[doTextHelper alloc]StrToLong:date :INT16_MAX];
        datePicker.date = [NSDate dateWithTimeIntervalSince1970:(currentDate / 1000)];
    }
    else
    {
        datePicker.date = [NSDate date];
    }
    if (minDate.length > 0) {
        double min = [[doTextHelper alloc]StrToLong:minDate :INT16_MAX];
        datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:(min / 1000)];
    }
    else
    {
        datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    if (maxDate.length > 0) {
        double max = [[doTextHelper alloc]StrToLong:maxDate :INT16_MAX];
        datePicker.maximumDate = [NSDate dateWithTimeIntervalSince1970:(max / 1000)];
    }
    else
    {
        datePicker.maximumDate = [NSDate dateWithTimeIntervalSince1970:(4070880000)];
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
    long selectTime;
    NSString *flag = [NSString stringWithFormat:@"%ld", (long)++buttonIndex];
    if (self.dateType == 0) {
        selectTime = self.tempDateView.date.timeIntervalSince1970 * 1000;
    }
    else if(self.dateType == 1)
    {
        selectTime = self.tempDateView.date.timeIntervalSince1970 * 1000;
    }
    else
    {
        selectTime = self.tempTimeView.date.timeIntervalSince1970 * 1000;
    }
    [resultNode setValue:[NSString stringWithFormat:@"%ld",selectTime]forKey:@"time"];
    [resultNode setValue:flag forKey:@"flag"];
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
    [_invokeResult SetResultNode:resultNode];
    [_scritEngine Callback:_callbackName :_invokeResult];
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSMutableDictionary *resultNode = [NSMutableDictionary dictionary];
//    long selectTime;
//    NSString *flag = [NSString stringWithFormat:@"%ld", (long)++buttonIndex];
//    if (self.dateType == 0) {
//        selectTime = self.tempDateView.date.timeIntervalSince1970 * 1000;
//    }
//    else if(self.dateType == 1)
//    {
//        selectTime = self.tempDateView.date.timeIntervalSince1970 * 1000;
//    }
//    else
//    {
//        selectTime = self.tempTimeView.date.timeIntervalSince1970 * 1000;
//    }
//   [resultNode setValue:[NSString stringWithFormat:@"%ld",selectTime]forKey:@"time"];
//   [resultNode setValue:flag forKey:@"flag"];
//    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
//    [_invokeResult SetResultNode:resultNode];
//    [_scritEngine Callback:_callbackName :_invokeResult];
//}

@end