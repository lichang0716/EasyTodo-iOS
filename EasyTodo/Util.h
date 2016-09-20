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

@end
