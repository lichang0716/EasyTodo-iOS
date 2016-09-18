//
//  Util.m
//  EasyTodo
//
//  Created by pwnlc on 16/9/18.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (int)getCurrentUnixTimeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString.intValue;
}

@end
