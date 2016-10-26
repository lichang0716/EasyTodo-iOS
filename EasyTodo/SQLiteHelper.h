//
//  SQLiteHelper.h
//  EasyTodo
//
//  Created by pwnlc on 2016/10/25.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TodoItem.h"

@interface SQLiteHelper : NSObject

- (void)insertNewItem:(TodoItem *)todoItem;

- (void)deleteItem:(TodoItem *)todoItem;

- (void)modifyItem:(TodoItem *)todoItem newDescription:(NSString *)description;

- (void)finishItem:(TodoItem *)todoItem;

- (NSMutableArray *)getListTodoTable;

- (void)updateListOrder:(NSArray *)todoItemListArr;

@end
