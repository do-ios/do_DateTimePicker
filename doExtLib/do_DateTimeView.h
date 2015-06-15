//
//  do_DataTimeView.h
//  Do_Test
//
//  Created by yz on 15/6/12.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol do_DateTimeViewDelegate <NSObject>

@optional
/**
 *  点击btn1
 */
- (void)leftBtnDidClick;
/**
 *  点击btn2
 */
- (void)rightBtnDidClick;
@end
/**
 *  自定义日期时间选择器
 */
@interface do_DateTimeView : UIView
@property(nonatomic,copy) NSString *date;
@property(nonatomic,copy) NSString *maxDate;
@property(nonatomic,copy) NSString *minDate;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *button1text;
@property(nonatomic,copy) NSString *button2text;
@property(nonatomic,assign)int type;
@property(nonatomic,weak) id <do_DateTimeViewDelegate>delegate;
- (instancetype)initDateTimeView:(int)type withDate:(NSString *)date withMaxDate:(NSString *)maxDate withMinDate:(NSString *)minDate withTitle:(NSString *)title withLeftBtn:(NSString *)left withRightBtn:(NSString *)right;
- (instancetype) initDateTimeView;
+ (instancetype) DataTime;
- (long) getTime;
@end
