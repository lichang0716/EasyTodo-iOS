//
//  Util.h
//  EasyTodo
//
//  Created by pwnlc on 16/9/18.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject

/**
 判断是否为第一次启动应用

 @return 判断结果
 */
+ (BOOL)isFirstTimeLaunch;

/**
 获取当前 Unix 时间戳

 @return 时间戳
 */
+ (int)getCurrentUnixTimeStamp;


/**
 给 textField 设置边框

 @param textField 需要设置边框的 textField
 @param color     边框颜色
 */
+ (void)setTextFieldBorder:(UITextField *)textField borderColor:(UIColor*)color;


/**
 把 Unix 时间戳转换为字符串日期

 @param unixTimeStamp Unix 时间戳

 @return 字符串日期
 */
+ (NSString *)getDateFormUnixTimeStamp:(int)unixTimeStamp;


/**
 Unix 时间戳转化为 day

 @param UnixTimeStamp 时间戳

 @return day int value
 */
+ (int)getDayValue:(int)UnixTimeStamp;


/**
 由 int day 转化为字符串形式显示到 tableView

 @param dayIntValue int day value

 @return 日期字符串形式
 */
+ (NSString *)getDateStr:(int)dayIntValue;

@end
