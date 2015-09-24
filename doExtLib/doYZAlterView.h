//
//  doYZAlterView.h
//  UIAlterViewDemo
//
//  Created by yz on 15/6/25.
//  Copyright (c) 2015年 DignalChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol doYZAlterViewDelegate <NSObject>

@optional
- (void)alertView:(UIView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface doYZAlterView : UIView
@property (nonatomic,strong) UIDatePicker *datePickerView;
@property (nonatomic,strong) UIDatePicker *timePickerView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) int buttonsCount;
@property (nonatomic,weak) id <doYZAlterViewDelegate>delegate;
- (instancetype)initWithTitle:(NSString *)title withButtons:(NSArray *)buttons withType:(int)type;
- (void)show;
@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithImage:(UIImage *)image withFrame:(CGRect)frame;

@end