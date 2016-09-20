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

+ (void)setTextFieldBorder:(UITextField *)textField borderColor:(UIColor*)color{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1.0;
    border.borderColor = color.CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
}

@end
