//
//  do_DateTimePicker_App.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_DateTimePicker_App.h"
static do_DateTimePicker_App* instance;
@implementation do_DateTimePicker_App
@synthesize OpenURLScheme;
+(id) Instance
{
    if(instance==nil)
        instance = [[do_DateTimePicker_App alloc]init];
    return instance;
}
@end
