//
//  TodayViewController.m
//  EasyTodoTodayExtenstion
//
//  Created by pwnlc on 2016/9/22.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#define CELL_IDENTIFIER     @"TodoExtenstionTableViewCell"

@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate, UITableViewDataSource> {
    float cellHeight;
    NSMutableArray *_contentArr;
}

@end

@implementation TodayViewController
@synthesize todoExtenstionTableView = _todoExtenstionTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentArr = [[NSMutableArray alloc] init];
    [_contentArr addObject:@"todoItem a"];
    [_contentArr addObject:@"todoItem b"];
    [_contentArr addObject:@"todoItem c"];
    [_contentArr addObject:@"todoItem d"];
    [_contentArr addObject:@"todoItem e"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        NSLog(@"执行 less");
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
        NSLog(@"self.view height = %f", self.view.frame.size.height);
        NSLog(@"todo table height = %f", _todoExtenstionTableView.frame.size.height);
    } else {
        NSLog(@"执行 large");
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 44 * _contentArr.count);
        NSLog(@"self.view height = %f", self.view.frame.size.height);
        NSLog(@"todo table height = %f", _todoExtenstionTableView.frame.size.height);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_todoExtenstionTableView reloadData];
        [self.view layoutIfNeeded];
    });
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.preferredContentSize.height / 3 > 44) {
        return 44;
    } else {
        return self.preferredContentSize.height / 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"布局 cell");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d. %@", (int)indexPath.row, _contentArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"执行 点击 cell");
    [self.extensionContext openURL:[NSURL URLWithString:@"appextension://xyz.pwnlc.EasyTodo"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];
}

@end
