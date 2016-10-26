//
//  TodoItem.h
//  EasyTodo
//
//  Created by pwnlc on 16/9/18.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 EasyTodo item 类。
 */
@interface TodoItem : NSObject

/**
 Todo item 描述。
 */
@property (nonatomic, copy) NSString *itemDescription;

/**
 Todo item 创建时间戳。
 */
@property (nonatomic, assign) int createTime;

/**
 Todo item 完成时间戳。
 */
@property (nonatomic, assign) int finishTime;

/**
 Todo item 当前状态：默认为 0，完成后为 1。
 */
@property (nonatomic, assign) int status;

/**
 Todo item 位置顺序。
 */
@property (nonatomic, assign) int position;

/**
 带参构造函数

 @param itemDescription item 描述

 @return TodoItem 对象
 */
- (TodoItem *)initWithDescription:(NSString *)itemDescription;

@end
