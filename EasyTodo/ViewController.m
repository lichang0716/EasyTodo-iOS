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
#import "TodoItemTableViewCell.h"
#import "MacroDefine.h"
#import "Util.h"
#import "SQLiteHelper.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSMutableArray *_todoItemArr;
    NSMutableArray *_doneItemArr;
    NSString *_itemDescribeInit;
    TodoItem *_itemWantToChange;
    NSArray *_sharedItemArr;
    SQLiteHelper *sqlHelper;
}

@end

@implementation ViewController
@synthesize itemFlagSwitch = _itemFlagSwitch;
@synthesize itemDescribeTextField = _itemDescribeTextField;
@synthesize doneItemTableView = _doneItemTableView;
@synthesize todoItemTableView = _todoItemTableView;
@synthesize addItemButton = _addItemButton;
@synthesize longPressGesture = _longPressGesture;
@synthesize rightSlideGesture = _rightSlideGesture;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_itemFlagSwitch addTarget:self
                        action:@selector(switchItemFlag)
              forControlEvents:UIControlEventValueChanged];
    
    _doneItemTableView.dataSource = self;
    _todoItemTableView.dataSource = self;
    _todoItemTableView.delegate = self;
    _itemDescribeTextField.delegate = self;
    
    // 初始化界面的空间可视性设置
    _doneItemTableView.alpha = 0.0;
    _itemDescribeTextField.alpha = 0.0;
    // 初始化变量
    _todoItemArr = [[NSMutableArray alloc] init];
    _doneItemArr = [[NSMutableArray alloc] init];
    _itemDescribeInit = [[NSString alloc] init];
    _sharedItemArr = [[NSArray alloc] init];
    // 添加程序失去前台的监听
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    // 添加 3D touche NewItem
    [notificationCenter addObserver:self selector:@selector(addItem:) name:NEW_ITEM_NOTIFICATION_NAME object:nil];
    // 在进入后台之前调整位置
    [notificationCenter addObserver:self selector:@selector(updatePosition:) name:APP_ENTER_BACKGROUND object:nil];
    //
    sqlHelper = [[SQLiteHelper alloc] init];
    // 如果是第一次启动，加载初始数据
    if ([Util isFirstTimeLaunch]) {
        [self initData];
        _sharedItemArr = [self getExtenstionItemDescription:_todoItemArr];
    } else {
        NSMutableArray *allItemArr = [sqlHelper getListTodoTable];
//        NSLog(@"allItemArr = %@", allItemArr);
        [self initDataWithSQLite:allItemArr];
    }
}

- (void)viewDidLayoutSubviews {
    // 给文本框设置下边框
    [Util setTextFieldBorder:_itemDescribeTextField borderColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark view methods

- (void)switchItemFlag {
    switch (_itemFlagSwitch.selectedSegmentIndex) {
        case 0:
            _todoItemTableView.alpha = 1.0;
            _doneItemTableView.alpha = 0.0;
            [self showBarItems];
            break;
        case 1:
            _todoItemTableView.alpha = 0.0;
            _doneItemTableView.alpha = 1.0;
//            if (_itemDescribeTextField.alpha > 0) {
//                _itemDescribeTextField.alpha = 0.0;
////                [self operateItemDescribeTextField];
//            }
            [_itemDescribeTextField resignFirstResponder];
            [self hiddenBarItems];
            [_doneItemTableView reloadData];
            break;
        default:
            break;
    }
}

- (void)showBarItems {
    _addItemButton.enabled = YES;
    _addItemButton.tintColor = nil;
}

- (void)hiddenBarItems {
    _addItemButton.enabled = NO;
    _addItemButton.tintColor = [UIColor clearColor];
}

- (IBAction)addItem:(id)sender {
    _addItemButton.enabled = NO;
    [_itemDescribeTextField becomeFirstResponder];
    _todoItemTableView.alpha = 0.0;
    _doneItemTableView.alpha = 0.0;
    _itemDescribeTextField.alpha = 1.0;
    _itemDescribeInit = EMPTY_STR;
    _itemDescribeTextField.text = _itemDescribeInit;
}

- (void)insertNewTodoItem {
    TodoItem *newTodoItem = [[TodoItem alloc] initWithDescription:_itemDescribeTextField.text];
    [_todoItemArr insertObject:newTodoItem atIndex:0];
    NSInteger lastRow = [_todoItemArr indexOfObject:newTodoItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [_todoItemTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//    NSLog(@"_todoItemArr = %@", _todoItemArr);
    _sharedItemArr = [self getExtenstionItemDescription:_todoItemArr];
    [sqlHelper insertNewItem:newTodoItem];
//    NSLog(@"newTodoItem = %@", newTodoItem);
//    NSLog(@"执行这里444444");
//    [self updatePosition:_todoItemArr];
}

- (void)modifyTodoItem:(TodoItem *)todoItem {
    todoItem.itemDescription = _itemDescribeTextField.text;
    [_todoItemTableView reloadData];
    NSLog(@"_todoItemArr = %@", _todoItemArr);
    _sharedItemArr = [self getExtenstionItemDescription:_todoItemArr];
}

- (void)operateItemDescribeTextField {
    if (_itemDescribeInit.length > 0 && ![_itemDescribeTextField.text isEqualToString:_itemDescribeInit]) {
        [sqlHelper modifyItem:_itemWantToChange newDescription:_itemDescribeTextField.text];
        [self modifyTodoItem:_itemWantToChange];
    } else if(_itemDescribeInit.length == 0 && _itemDescribeTextField.text.length > 0){
        [self insertNewTodoItem];
//        NSLog(@"执行这里333333");
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
    TodoItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!cell){
        cell = [[TodoItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    if (tableView == _todoItemTableView) {
        TodoItem *todoItem = _todoItemArr[indexPath.row];
        cell.cellDescription.text=[todoItem itemDescription];
    } else {
        DoneItemGroup *_doneItemGroup = _doneItemArr[indexPath.section];
        TodoItem *todoItem = _doneItemGroup.doneItemsArr[indexPath.row];
        cell.cellDescription.text = [todoItem itemDescription];
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == _doneItemTableView) {
        DoneItemGroup *group = _doneItemArr[section];
        NSString *groupName = [NSString stringWithFormat:@"%@", group.finishTime];
        return groupName;
    } else {
        return nil;
    }
}

#pragma mark click edit item
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _todoItemTableView.alpha = 0.0;
    _doneItemTableView.alpha = 0.0;
    TodoItem *selectedItem = _todoItemArr[indexPath.row];
    _itemWantToChange = selectedItem;
    _itemDescribeInit = selectedItem.itemDescription;
    _itemDescribeTextField.text = _itemDescribeInit;
    _itemDescribeTextField.alpha = 1.0;
    [_itemDescribeTextField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:RETURN]) {
        [_itemDescribeTextField resignFirstResponder];
        _todoItemTableView.alpha = 1.0;
        _addItemButton.enabled = YES;
        [self operateItemDescribeTextField];
//        NSLog(@"执行这里111111");
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *>*)touches withEvent:(UIEvent *)event {
    [_itemDescribeTextField resignFirstResponder];
    _todoItemTableView.alpha = 1.0;
    _addItemButton.enabled = YES;
    [self operateItemDescribeTextField];
//    NSLog(@"执行这里222222");
}

#pragma mark right slide mark done

- (IBAction)rightSlideTodoTableView:(id)sender {
    CGPoint location = [sender locationInView:_todoItemTableView];
    NSIndexPath *indexPath = [_todoItemTableView indexPathForRowAtPoint:location];
    if (indexPath) {
        [NSThread sleepForTimeInterval:0.1];
        [self setDoneItemArr:_todoItemArr[indexPath.row]];
        [sqlHelper finishItem:_todoItemArr[indexPath.row]];
//        [self updatePosition:_todoItemArr];
        [_todoItemArr removeObjectAtIndex:indexPath.row];
        [_todoItemTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        NSLog(@"_todoItemArr = %@", _todoItemArr);
        _sharedItemArr = [self getExtenstionItemDescription:_todoItemArr];
    }
}

- (void)setDoneItemArr:(TodoItem *)todoItem {
    todoItem.finishTime = [Util getCurrentUnixTimeStamp];
    /* 遍历 doneItemArr
       如果当前时间戳已经有了，那么就直接插入
       如果没有时间戳，那么新建 group
    */
    if (_doneItemArr.count < 1) {
        todoItem.finishTime = [Util getCurrentUnixTimeStamp];
        NSMutableArray *doneItemArrObject0 = [[NSMutableArray alloc] initWithObjects:todoItem, nil];
        DoneItemGroup *group0 = [[DoneItemGroup alloc] init];
        group0.finishTime = [Util getDateFormTimeStamp:todoItem.finishTime];
        group0.doneItemsArr = doneItemArrObject0;
        [_doneItemArr addObject:group0];
    } else {
        for (DoneItemGroup *doneItemGroup in _doneItemArr) {
            if ([doneItemGroup.finishTime isEqualToString:[Util getDateFormTimeStamp:todoItem.finishTime]]) {
                [doneItemGroup.doneItemsArr insertObject:todoItem atIndex:0];
                todoItem.finishTime = [Util getCurrentUnixTimeStamp];
            }
        }
        if (todoItem.finishTime < 1) {
            todoItem.finishTime = [Util getCurrentUnixTimeStamp];
            NSMutableArray *doneItemArrObject0 = [[NSMutableArray alloc] initWithObjects:todoItem, nil];
            DoneItemGroup *group0 = [[DoneItemGroup alloc] init];
            group0.finishTime = [Util getDateFormTimeStamp:todoItem.finishTime];
            group0.doneItemsArr = doneItemArrObject0;
            [_doneItemArr addObject:group0];
        }
    }
}

#pragma mark left slide delete

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DELETE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [sqlHelper deleteItem:_todoItemArr[indexPath.row]];
    [_todoItemArr removeObjectAtIndex:indexPath.row];
    [_todoItemTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    NSLog(@"_todoItemArr = %@", _todoItemArr);
    _sharedItemArr = [self getExtenstionItemDescription:_todoItemArr];
}

#pragma mark long press gesture

- (IBAction)longPressTodoTableView:(id)sender {
    UILongPressGestureRecognizer *longPressGes = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPressGes.state;
    
    CGPoint location = [longPressGes locationInView: _todoItemTableView];
    NSIndexPath *indexPath = [_todoItemTableView indexPathForRowAtPoint:location];
    
    static UIView *snapShot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [_todoItemTableView cellForRowAtIndexPath:indexPath];
                
                snapShot = [self getCustomeSnapShot:cell];
                
                __block CGPoint center = cell.center;
                snapShot.center = center;
                snapShot.alpha = 1.0f;
                [_todoItemTableView addSubview:snapShot];
                
                [UIView animateWithDuration:0.25 animations:^{
                    center = CGPointMake(center.x, location.y);
                    snapShot.center = center;
                    snapShot.transform = CGAffineTransformScale(snapShot.transform, 1.0, 1.0);
                    snapShot.alpha = 1.0;
                }];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint center = snapShot.center;
            snapShot.center = CGPointMake(center.x, location.y);
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [_todoItemArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [_todoItemTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
//                NSLog(@"_todoItemArr = %@", _todoItemArr);
                _sharedItemArr = [self getExtenstionItemDescription:_todoItemArr];
            }
        }
            break;
        default:
        {
            UITableViewCell *cell = [_todoItemTableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.5 animations:^{
                snapShot.center = cell.center;
                snapShot.transform = CGAffineTransformIdentity;
                snapShot.alpha = 1.0f;
                cell.backgroundColor = [UIColor clearColor];
                
            } completion:^(BOOL finished) {
                [snapShot removeFromSuperview];
                snapShot = nil;
                
            }];
            sourceIndexPath = nil;
        }
            break;
    }
}

- (UIView *)getCustomeSnapShot:(UIView *)inputView
{
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    return snapshot;
}

#pragma mark set simulation data
- (void)initData {
    TodoItem *todoItem0 = [[TodoItem alloc] initWithDescription:@"左划可以删除 item"];
    TodoItem *todoItem1 = [[TodoItem alloc] initWithDescription:@"长按可以移动 item"];
    TodoItem *todoItem2 = [[TodoItem alloc] initWithDescription:@"右划可以完成 item"];
    TodoItem *todoItem3 = [[TodoItem alloc] initWithDescription:@"点击可以编辑 item"];
    TodoItem *todoItem4 = [[TodoItem alloc] initWithDescription:@"点击 Add 可以添加 item"];
    TodoItem *todoItem5 = [[TodoItem alloc] initWithDescription:@"Enjoy it !"];
    [_todoItemArr addObject:todoItem0];
    [_todoItemArr addObject:todoItem1];
    [_todoItemArr addObject:todoItem2];
    [_todoItemArr addObject:todoItem3];
    [_todoItemArr addObject:todoItem4];
    [_todoItemArr addObject:todoItem5];
}

- (void)initDataWithSQLite:(NSMutableArray *)todoListArr {
    if (todoListArr.count > 0) {
        for (TodoItem *todoItem in todoListArr) {
            if (todoItem.status == 0 && todoItem.position >= 0) {
                [_todoItemArr insertObject:todoItem atIndex:todoItem.position];
            } else {
                [self setDoneItemArr:todoItem];
            }
        }
    }
}

#pragma mark Application Will Resign Active

- (void)applicationWillResignActive{
    // 在程序进入后台之前执行这里
    [self saveSharedUserDefaults];
    [self updatePosition:_todoItemArr];
}

- (void)saveSharedUserDefaults {
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:USERDEFAULT_SUITNAME];
    [userDefault setObject:_sharedItemArr forKey:USERDEFAULT_KEY];
    [userDefault synchronize];  
}

- (NSArray *)getExtenstionItemDescription:(NSMutableArray *)todoItemArr {
    NSString *firstItemDes = [self getIndexStrFromTodoArr:0];
    NSString *secondItemDes = [self getIndexStrFromTodoArr:1];
    NSString *thirdItemDes = [self getIndexStrFromTodoArr:2];
    NSArray *extenstionItemsArr = [[NSArray alloc] initWithObjects:firstItemDes, secondItemDes, thirdItemDes, nil];
    return extenstionItemsArr;
}

- (NSString *)getIndexStrFromTodoArr:(int)index {
    if (index < _todoItemArr.count) {
        TodoItem *item = _todoItemArr[index];
        return item.itemDescription;
    } else {
        return EMPTY_STR;
    }
}

- (void)updatePosition:(NSMutableArray *)todoListArr {
//    NSLog(@"需要更新的 todoList = %@", todoListArr);
    [sqlHelper updateListOrder:todoListArr];
}

@end
