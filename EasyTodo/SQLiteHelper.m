//
//  SQLiteHelper.m
//  EasyTodo
//
//  Created by pwnlc on 2016/10/25.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import "SQLiteHelper.h"

@interface SQLiteHelper(){
    sqlite3 *database;
}

@end

@implementation SQLiteHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initDatabase {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [documentPath stringByAppendingPathComponent:@"todoList.db"];
    NSLog(@"path = %@", path);
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        NSLog(@"open successfully");
        [self createTable];
    } else {
        NSLog(@"open database error, %s", sqlite3_errmsg(database));
    }
}

- (void)createTable {
    NSString *sqlCreateTable = @"create table if not exists todolist (id integer primary key autoincrement, itemcontent text, createtime integer, finishtime integer, status integer, position integer)";
    char *errMsg;
    if (sqlite3_exec(database, [sqlCreateTable UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog(@"创建表格错误，错误 = %s", errMsg);
    }
}

- (void)insertNewItem:(TodoItem *)todoItem {
    NSLog(@"执行这里 555555");
    [self initDatabase];
    char *errMsg = NULL;
    NSString *sqlInsert = [NSString stringWithFormat:@"insert into todolist('itemcontent', 'createtime', 'status', 'position') values ('%@', '%d', '%@', '%@')", todoItem.itemDescription, todoItem.createTime, @"0", @"0"];
    if (sqlite3_exec(database, [sqlInsert UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog(@"errMSG = %s", errMsg);
    } else {
        NSLog(@"插入成功！");
    }
    // 插入成功之后得去调整其他 Item 的顺序！
    // 没有必要现在就调整顺序，可以在一次应用推出后再进行调整
    sqlite3_close(database);
}

- (void)modifyItem:(TodoItem *)todoItem newDescription:(NSString *)description{
    NSLog(@"执行修改 item");
    [self initDatabase];
    char *errMsg = NULL;
    NSString *sqlUpdate = [NSString stringWithFormat:@"update todolist set itemcontent = '%@' where itemcontent = '%@' and createtime = '%d'", description, todoItem.itemDescription, todoItem.createTime];
    if (sqlite3_exec(database, [sqlUpdate UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog(@"更新失败，error = %s", errMsg);
    } else {
        NSLog(@"更新成功！");
    }
    sqlite3_close(database);
}

- (void)finishItem:(TodoItem *)todoItem {
    NSLog(@"完成 item");
    [self initDatabase];
    char *errMsg = NULL;
    NSString *sqlUpdate = [NSString stringWithFormat:@"update todolist set status = '%@', finishtime = '%d' where itemcontent = '%@' and createtime = '%d'", @"1", todoItem.finishTime, todoItem.itemDescription, todoItem.createTime];
    if (sqlite3_exec(database, [sqlUpdate UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog(@"更新失败，error = %s", errMsg);
    } else {
        NSLog(@"更新成功！");
    }
    sqlite3_close(database);
}

- (void)deleteItem:(TodoItem *)todoItem {
    NSLog(@"删除 item");
    [self initDatabase];
    char *errMsg = NULL;
    NSString *sqlUpdate = [NSString stringWithFormat:@"delete from todolist where itemcontent = '%@' and createtime = '%d'", todoItem.itemDescription, todoItem.createTime];
    if (sqlite3_exec(database, [sqlUpdate UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog(@"删除失败，error = %s", errMsg);
    } else {
        NSLog(@"删除成功！");
    }
    sqlite3_close(database);
}

- (NSMutableArray *)getListTodoTable {
    NSMutableArray *todoItemArr = [[NSMutableArray alloc] init];
    [self initDatabase];
    NSString *select = [NSString stringWithFormat:@"select itemcontent, createtime, finishtime, status, position from todolist"];
    sqlite3_stmt *statement;
    int sqlResult = sqlite3_prepare_v2(database, [select UTF8String], -1, &statement, NULL);
    if (sqlResult == SQLITE_OK) {
        NSLog(@"查询成功！😄");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            TodoItem *item = [[TodoItem alloc] init];
            item.itemDescription = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 0)];
            item.createTime = sqlite3_column_int(statement, 1);
            item.finishTime = sqlite3_column_int(statement, 2);
            item.status = sqlite3_column_int(statement, 3);
            item.position = sqlite3_column_int(statement, 4);
//            [todoItemArr insertObject:item atIndex:item.position];
            [todoItemArr addObject:item];
            NSLog(@"是这里出错的吗？？？？？");
        }
    } else {
        NSLog(@"查询失败！");
    }
    NSSortDescriptor *itemPositionDesc = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
    NSSortDescriptor *itemStatusDesc = [NSSortDescriptor sortDescriptorWithKey:@"status" ascending:YES];
    NSArray *descriptorArray = [NSArray arrayWithObjects:itemPositionDesc, itemStatusDesc, nil];
    todoItemArr = (NSMutableArray *)[todoItemArr sortedArrayUsingDescriptors: descriptorArray];
    sqlite3_close(database);
    return todoItemArr;
}

- (void)updateListOrder:(NSArray *)todoItemListArr {
    if (todoItemListArr.count > 0) {
        for (int i = 0; i < todoItemListArr.count; i++) {
            TodoItem *todoItem = todoItemListArr[i];
            [self modifyItemPosition:todoItem postion:i];
        }
    }
    sqlite3_close(database);
}

- (void)modifyItemPosition:(TodoItem *)todoItem postion:(int)position {
    NSLog(@"修改 item 顺序");
    [self initDatabase];
    char *errMsg = NULL;
    NSString *sqlUpdate = [NSString stringWithFormat:@"update todolist set position = '%d' where itemcontent = '%@' and createtime = '%d'", position, todoItem.itemDescription, todoItem.createTime];
    if (sqlite3_exec(database, [sqlUpdate UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog(@"更新失败，error = %s", errMsg);
    } else {
        NSLog(@"更新成功！");
    }
}

@end
