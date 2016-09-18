//
//  ViewController.m
//  EasyTodo
//
//  Created by pwnlc on 16/9/17.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import "ViewController.h"
#import "TodoItem.h"
#import "DoneItemGroup.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_todoItemArr;
    NSMutableArray *_doneItemArr;
}

@end

@implementation ViewController
@synthesize itemFlagSwitch = _itemFlagSwitch;
@synthesize doneItemTableView = _doneItemTableView;
@synthesize todoItemTableView = _todoItemTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [_itemFlagSwitch addTarget:self
                        action:@selector(switchItemFlag)
              forControlEvents:UIControlEventValueChanged];
    
    _doneItemTableView.dataSource = self;
    _todoItemTableView.dataSource = self;
    
    _doneItemTableView.alpha = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark view methods

- (void)switchItemFlag {
    switch (_itemFlagSwitch.selectedSegmentIndex) {
        case 0:
            // 为 todo 的情况
            _todoItemTableView.alpha = 1.0;
            _doneItemTableView.alpha = 0.0;
            break;
        case 1:
            // 为 done 的情况
            _todoItemTableView.alpha = 0.0;
            _doneItemTableView.alpha = 1.0;
            break;
        default:
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _todoItemTableView) {
        return 1;
    }else {
        return _doneItemArr.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _todoItemTableView) {
        return _todoItemArr.count;
    }else {
        DoneItemGroup *_doneItemGroup = _doneItemArr[section];
        return _doneItemGroup.doneItemsArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (tableView == _todoItemTableView) {
        TodoItem *todoItem = _todoItemArr[indexPath.row];
        cell.textLabel.text=[todoItem itemDescription];
    } else {
        DoneItemGroup *_doneItemGroup = _doneItemArr[indexPath.section];
        TodoItem *todoItem = _doneItemGroup.doneItemsArr[indexPath.row];
        cell.textLabel.text=[todoItem itemDescription];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d", todoItem.createTime];
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == _doneItemTableView) {
        DoneItemGroup *group = _doneItemArr[section];
        NSString *groupName = [NSString stringWithFormat:@"%d", group.finishTime];
        return groupName;
    } else {
        return nil;
    }
}

#pragma mark set simulation data
- (void)initData {
    _todoItemArr = [[NSMutableArray alloc] init];
    TodoItem *todoItem0 = [[TodoItem alloc] initWithDescription:@"todo list item 0"];
    TodoItem *todoItem1 = [[TodoItem alloc] initWithDescription:@"todo list item 1"];
    TodoItem *todoItem2 = [[TodoItem alloc] initWithDescription:@"todo list item 2"];
    TodoItem *todoItem3 = [[TodoItem alloc] initWithDescription:@"todo list item 3"];
    TodoItem *todoItem4 = [[TodoItem alloc] initWithDescription:@"todo list item 4"];
    TodoItem *todoItem5 = [[TodoItem alloc] initWithDescription:@"todo list item 5"];
    [_todoItemArr addObject:todoItem0];
    [_todoItemArr addObject:todoItem1];
    [_todoItemArr addObject:todoItem2];
    [_todoItemArr addObject:todoItem3];
    [_todoItemArr addObject:todoItem4];
    [_todoItemArr addObject:todoItem5];
    // ----------------------------------------------------------
    _doneItemArr = [[NSMutableArray alloc] init];
    TodoItem *doneItem0 = [[TodoItem alloc] initWithDescription:@"Bitcode 的问题"];
    doneItem0.finishTime = 1474203051;
    NSMutableArray *doneItemArrObject0 = [[NSMutableArray alloc] initWithObjects:doneItem0, nil];
    DoneItemGroup *group0 = [[DoneItemGroup alloc] init];
    group0.finishTime = 1474203051;
    group0.doneItemsArr = doneItemArrObject0;
    
    TodoItem *doneItem1 = [[TodoItem alloc] initWithDescription:@"返回键盘不先退出"];
    TodoItem *doneItem2 = [[TodoItem alloc] initWithDescription:@"bundle 打包"];
    doneItem1.finishTime = 1474116646;
    doneItem2.finishTime = 1474116650;
    NSMutableArray *doneItemArrObject1 = [[NSMutableArray alloc] initWithObjects:doneItem1, doneItem2, nil];
    DoneItemGroup *group1 = [[DoneItemGroup alloc] init];
    group1.finishTime = 1474116646;
    group1.doneItemsArr = doneItemArrObject1;
    
    TodoItem *doneItem3 = [[TodoItem alloc] initWithDescription:@"隐藏显示密码字体不同"];
    TodoItem *doneItem4 = [[TodoItem alloc] initWithDescription:@"更改 SDK int 时间戳"];
    TodoItem *doneItem5 = [[TodoItem alloc] initWithDescription:@"测试测试服务器"];
    doneItem3.finishTime = 1474030246;
    doneItem4.finishTime = 1474030247;
    doneItem5.finishTime = 1474030248;
    NSMutableArray *doneItemArrObject2 = [[NSMutableArray alloc] initWithObjects:doneItem3, doneItem4, doneItem5, nil];
    DoneItemGroup *group2 = [[DoneItemGroup alloc] init];
    group2.finishTime = 1474030246;
    group2.doneItemsArr = doneItemArrObject2;
    
    [_doneItemArr addObject:group0];
    [_doneItemArr addObject:group1];
    [_doneItemArr addObject:group2];
}

@end
