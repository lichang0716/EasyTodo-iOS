//
//  EasyTodoTests.m
//  EasyTodoTests
//
//  Created by pwnlc on 16/9/21.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Util.h"

@interface EasyTodoTests : XCTestCase

@end

@implementation EasyTodoTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark test Util

- (void)testGetDateFormUnixTimeStamp {
    int testUnixTimeStamp = 1474116646;
    NSString *returnStr = [Util getDateFormUnixTimeStamp:testUnixTimeStamp];
    XCTAssertTrue([returnStr isEqualToString:@"2016.09.17"], @"转换后的字符串和预期不相符，转换后为 %@", returnStr);
}

@end
