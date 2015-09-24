//
//  doYZAlterView.m
//  UIAlterViewDemo
//
//  Created by yz on 15/6/25.
//  Copyright (c) 2015年 DignalChina. All rights reserved.
//
#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kAlertWidth 280.0f
#define kContentHeitht 216.0f
#define kButtonHeight 40.0f

#import "doYZAlterView.h"
@interface doYZAlterView()
@property (nonatomic,strong) UIView *shadView;
@end

@implementation doYZAlterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithTitle:(NSString *)title withButtons:(NSArray *)buttons withType:(int)type
{
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = title;
        titleLab.font = [UIFont boldSystemFontOfSize:20.0f];
        titleLab.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
        [self addSubview:titleLab];
        if (!buttons) {
            buttons = @[@"取消",@"确定"];
        }
        if (buttons.count <= 2) {
            CGFloat btnW = kAlertWidth / buttons.count;
            CGFloat btnH = kButtonHeight;
            for (int i = 0; i < buttons.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//                btn.layer.borderWidth = 1;
//                btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                if (type == 0) {
                    btn.frame = CGRectMake(i * btnW, 2 * kContentHeitht + kTitleHeight + kTitleYOffset , btnW, btnH);
                }
                else
                {
                    btn.frame = CGRectMake(i * btnW,  kContentHeitht + kTitleHeight + kTitleYOffset, btnW, btnH);
                }
                UIImage *bgImage;
                if (i == 0) {//设置左边按钮bg
                    bgImage = [UIImage imageNamed:@"do_DateTimePicker.bundle/leftbg.png"];
                }
                else if (i == (buttons.count - 1))//设置右边按钮bg
                {
                    bgImage = [UIImage imageNamed:@"do_DateTimePicker.bundle/rightbg.png"];
                }
                else
                {
                    bgImage = [UIImage imageNamed:@"do_DateTimePicker.bundle/middlebg.png"];
                }
                bgImage = [UIImage imageWithImage:bgImage withFrame:btn.frame];
                [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
                [btn setTitle:buttons[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self addSubview:btn];
            }
        }
        else
        {
            CGFloat btnW = kAlertWidth;
            CGFloat btnH = kButtonHeight;
            for (int i = 0; i < buttons.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//                btn.layer.borderWidth = 1;
//                btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                if (type == 0) {
                    btn.frame = CGRectMake(0, 2 * kContentHeitht + i * kButtonHeight, btnW, btnH);
                }
                else
                {
                    btn.frame = CGRectMake(0,  kContentHeitht + i * kButtonHeight + 120 - (kButtonHeight *(i + 1)), btnW, btnH);
                }
                UIImage *bgImage;
                if (i == 0) {//设置左边按钮bg
                    bgImage = [UIImage imageNamed:@"do_DateTimePicker.bundle/leftbg.png"];
                }
                else if (i == (buttons.count - 1))//设置右边按钮bg
                {
                    bgImage = [UIImage imageNamed:@"do_DateTimePicker.bundle/rightbg.png"];
                }
                else
                {
                    bgImage = [UIImage imageNamed:@"do_DateTimePicker.bundle/middlebg.png"];
                }
                bgImage = [UIImage imageWithImage:bgImage withFrame:btn.frame];
                [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
                [btn setTitle:buttons[i] forState:UIControlStateNormal];
                [self addSubview:btn];
            }
        }
    }
    return self;
}
- (void)setDatePickerView:(UIDatePicker *)datePickerView
{
    datePickerView.frame = CGRectMake(2,kTitleYOffset + kTitleHeight , kAlertWidth, kContentHeitht);
    [self addSubview:datePickerView];

}

- (void)setTimePickerView:(UIDatePicker *)timePickerView
{
    timePickerView.frame = CGRectMake(2, kTitleYOffset + kTitleHeight + kContentHeitht, kAlertWidth, kContentHeitht);
    [self addSubview:timePickerView];

}

- (void)setContentView:(UIView *)contentView
{
//    contentView.frame = CGRectMake(2, kTitleYOffset + kTitleHeight, kAlertWidth, kAlertHeight);
    [self addSubview:contentView];

}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    CGFloat alterHeight;
    if (self.type == 0) {
        if (self.buttonsCount > 2) {
            alterHeight = kTitleYOffset + kTitleHeight + 2 * kContentHeitht + self.buttonsCount * kButtonHeight;

        }
        else
        {
            alterHeight = kTitleYOffset + kTitleHeight + 2 * kContentHeitht + kButtonHeight;
        }
    }
    else
    {
        if (self.buttonsCount > 2) {
            alterHeight = kTitleYOffset + kTitleHeight + kContentHeitht + self.buttonsCount * kButtonHeight;
        }
        else
        {
            alterHeight = kTitleYOffset + kTitleHeight + kContentHeitht + kButtonHeight;
        }
    }
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - alterHeight) * 0.5, kAlertWidth, alterHeight);
//    UIImage *backImage = [UIImage imageWithImage:[UIImage imageNamed:@"do_DateTimePicker.bundle/background.png"] withFrame:self.frame];
    self.backgroundColor = [UIColor whiteColor];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    UIView *shadView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, screenW, screenH - 20)];
    shadView.backgroundColor = [UIColor grayColor];
    shadView.alpha = 0.5;
    UITapGestureRecognizer *shadViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shadViewTap:)];
    [shadView addGestureRecognizer:shadViewTap];
    self.shadView = shadView;
    [UIView animateWithDuration:0.25 animations:^{
        [self addSubview:shadView];
        [topVC.view addSubview:shadView];
        [topVC.view addSubview:self];

    }];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
- (void)btnClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.shadView removeFromSuperview];
    }];
    [self.shadView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:sender.tag];
    }
}
- (void)shadViewTap:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.shadView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithImage:(UIImage *)image withFrame:(CGRect)frame
{
    UIEdgeInsets insets = UIEdgeInsetsMake(frame.size.height / 2, frame.size.width / 2, frame.size.height / 2, frame.size.width / 2);
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

@end
