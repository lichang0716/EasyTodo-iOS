//
//  ViewController.h
//  EasyTodo
//
//  Created by pwnlc on 16/9/17.
//  Copyright © 2016年 xyz.pwnlc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *itemFlagSwitch;
@property (weak, nonatomic) IBOutlet UITextField *itemDescribeTextField;
@property (weak, nonatomic) IBOutlet UITableView *doneItemTableView;
@property (weak, nonatomic) IBOutlet UITableView *todoItemTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItemButton;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSlideGesture;

- (IBAction)addItem:(id)sender;
- (IBAction)longPressTodoTableView:(id)sender;
- (IBAction)rightSlideTodoTableView:(id)sender;

@end

