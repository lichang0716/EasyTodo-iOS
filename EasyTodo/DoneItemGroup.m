//
//  DoneItemGroup.m
//  EasyTodo
//
//  Created by pwnlc on 16/9/18.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import "DoneItemGroup.h"
#import "Util.h"

@implementation DoneItemGroup

- (instancetype)init {
    self = [super init];
    if (self) {
        _finishTime = 0;
        _doneItemsArr = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
