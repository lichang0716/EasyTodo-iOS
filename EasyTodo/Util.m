//
//  Util.m
//  EasyTodo
//
//  Created by pwnlc on 16/9/18.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import "Util.h"
#import "MacroDefine.h"

@implementation Util

+ (BOOL)isFirstTimeLaunch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:FIRST_TIME_LAUNCH]) {
        [defaults setBool:NO forKey:FIRST_TIME_LAUNCH];
        [defaults synchronize];
        return NO;
    } else {
        [defaults setBool:YES forKey:FIRST_TIME_LAUNCH];
        [defaults synchronize];
        return YES;
    }
}

+ (int)getCurrentUnixTimeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString.intValue;
}

+ (NSString *)getDateFormTimeStamp:(int)timeStamp {
    NSDate *confromTimeStamp = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YY-MM-dd"];
    NSString *confromTimeStampStr = [formatter stringFromDate:confromTimeStamp];
    return confromTimeStampStr;
}

+ (BOOL)isSameDay:(int)timeStamp1 timeStamp2:(int)timeStamp2 {
    if (timeStamp1 / 3600 == timeStamp2 / 3600) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)setTextFieldBorder:(UITextField *)textField borderColor:(UIColor*)color{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1.0;
    border.borderColor = color.CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
}

+ (NSString *)getDateFormUnixTimeStamp:(int)unixTimeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTimeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = DATE_FORMATTER;
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

+ (int)getDayValue:(int)UnixTimeStamp {
    return UnixTimeStamp / DAYTIME;
}

+ (NSString *)getDateStr:(int)dayIntValue {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dayIntValue *DAYTIME];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yy.MM.dd";
    NSString *dateFormatterStr = [formatter stringFromDate:date];
    return dateFormatterStr;
}

@end
