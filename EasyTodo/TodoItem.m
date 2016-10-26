//
//  TodoItem.m
//  EasyTodo
//
//  Created by pwnlc on 16/9/18.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import "TodoItem.h"
#import "Util.h"

@implementation TodoItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _itemDescription = @"";
        _finishTime = 0;
        _createTime = [Util getCurrentUnixTimeStamp];
        _status = 0;
        _position = 0;
    }
    return self;
}

- (TodoItem *)initWithDescription:(NSString *)itemDescription {
    self = [super init];
    if (self) {
        _itemDescription = itemDescription;
        _createTime = [Util getCurrentUnixTimeStamp];
        _finishTime = 0;
        _status = 0;
        _position = 0;
    }
    return self;
}

@end
