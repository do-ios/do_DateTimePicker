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
#import "do_DateTimeView.h"
#import "doJsonHelper.h"
#import "doIScriptEngine.h"
#import "doIPage.h"


@interface do_DateTimePicker_SM()<do_DateTimeViewDelegate>
@property (nonatomic,strong) do_DateTimeView *tempDateView;
@property (nonatomic,weak) id<doIScriptEngine> scritEngine;
@property (nonatomic,strong) NSString *callbackName;
@property (nonatomic,copy) NSString *currentDate;
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
    NSString *date = [doJsonHelper GetOneText:_dictParas :@"data" :@""];
    self.currentDate = date;
    NSString *maxDate = [doJsonHelper GetOneText:_dictParas :@"maxDate" :@""];
    NSString *minDate = [doJsonHelper GetOneText:_dictParas :@"minDate" :@""];
    NSString *title = [doJsonHelper GetOneText:_dictParas :@"title" :@""];
    NSString *button1text = [doJsonHelper GetOneText:_dictParas :@"button1text" :@""];
    NSString *button2text = [doJsonHelper GetOneText:_dictParas :@"button2text" :@""];
    id<doIPage>pageModel = _scritEngine.CurrentPage;
    UIViewController *currentVc = (UIViewController *)pageModel.PageView;
    do_DateTimeView *dateView = [[do_DateTimeView alloc]initDateTimeView:type withDate:date withMaxDate:maxDate withMinDate:minDate withTitle:title withLeftBtn:button1text withRightBtn:button2text];
    self.tempDateView = dateView;
    //设置frame
    dispatch_async(dispatch_get_main_queue(), ^{
        dateView.frame = CGRectMake(0, 20, currentVc.view.frame.size.width, currentVc.view.frame.size.height - 20);
        dateView.backgroundColor = [UIColor whiteColor];
        [currentVc.view addSubview:dateView];
        dateView.delegate = self;
    });
}
#pragma mark -
#pragma mark do_DateTimeViewDelegate

- (void)leftBtnDidClick
{
    NSMutableDictionary *resultNode = [NSMutableDictionary dictionary];
    [resultNode setValue:@1 forKey:@"flag"];
    [resultNode setValue:self.currentDate forKey:@"time"];
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
    [_invokeResult SetResultNode:resultNode];
    [_scritEngine Callback:_callbackName :_invokeResult];
}
- (void)rightBtnDidClick
{
    NSString *selectedDate = [NSString stringWithFormat:@"%ld",[self.tempDateView getTime]];
    NSMutableDictionary *resultNode = [NSMutableDictionary dictionary];
    [resultNode setValue:@2 forKey:@"flag"];
    [resultNode setValue:selectedDate forKey:@"time"];
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
    [_invokeResult SetResultNode:resultNode];
    [_scritEngine Callback:_callbackName :_invokeResult];
}

@end