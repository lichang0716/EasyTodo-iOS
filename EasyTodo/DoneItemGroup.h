//
//  DoneItemGroup.h
//  EasyTodo
//
//  Created by pwnlc on 16/9/18.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 已完成 item group 类。
 */
@interface DoneItemGroup : NSObject

/**
 items 完成的日期。
 */
@property (nonatomic, copy) NSString *finishTime;

/**
 日期内完成的 items 数组。
 */
@property (nonatomic, strong) NSMutableArray *doneItemsArr;

@end
