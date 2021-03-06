//
//  UITextField+History.m
//  Demo
//
//  Created by DamonDing on 15/5/26.
//  Copyright (c) 2015年 morenotepad. All rights reserved.
//

#import "UITextField+History.h"
#import <objc/runtime.h>
#import "_greats.h"

#define history_X(view) (view.frame.origin.x)
#define history_Y(view) (view.frame.origin.y)
#define history_W(view) (view.frame.size.width)
#define history_H(view) (view.frame.size.height)

__unused static char kTextFieldIdentifyKey;
__unused static char kTextFieldHistoryviewIdentifyKey;

#define ANIMATION_DURATION 0.3f
#define ITEM_HEIGHT 40
#define CLEAR_BUTTON_HEIGHT 45
#define MAX_HEIGHT 300


@interface UITextField () <UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) UITableView *historyTableView;

@end


@implementation UITextField ( History )

@def_prop_custom(NSString *, identify, setIdentify, retain)

- (UITableView *)historyTableView {
    UITableView *table = objc_getAssociatedObject(self, &kTextFieldHistoryviewIdentifyKey);
    
    if (table == nil) {
        table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITextFieldHistoryCell"];
        table.layer.borderColor = [UIColor grayColor].CGColor;
        table.layer.borderWidth = 1;
        table.delegate = self;
        table.dataSource = self;
        objc_setAssociatedObject(self, &kTextFieldHistoryviewIdentifyKey, table, OBJC_ASSOCIATION_RETAIN);
    }
    
    return table;
}

- (NSArray*)loadHistroy {
    if (self.identify == nil) {
        return nil;
    }

    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dic = [def objectForKey:@"UITextField+JKHistory"];
    
    if (dic != nil) {
        return [dic objectForKey:self.identify];
    }

    return nil;
}

- (void)synchronize {
    if (self.identify == nil || [self.text length] == 0) {
        return;
    }
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dic = [def objectForKey:@"UITextField+JKHistory"];
    NSArray* history = [dic objectForKey:self.identify];
    
    NSMutableArray* newHistory = [NSMutableArray arrayWithArray:history];
    
    __block BOOL haveSameRecord = false;
    __weak typeof(self) weakSelf = self;
    
    [newHistory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(NSString*)obj isEqualToString:weakSelf.text]) {
            *stop = true;
            haveSameRecord = true;
        }
    }];
    
    if (haveSameRecord) {
        return;
    }
    
    [newHistory addObject:self.text];
    
    NSMutableDictionary* dic2 = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic2 setObject:newHistory forKey:self.identify];
    
    [def setObject:dic2 forKey:@"UITextField+JKHistory"];
    
    [def synchronize];
}

- (void)showHistory {
    NSArray* history = [self loadHistroy];
    
    if (self.historyTableView.superview != nil || history == nil || history.count == 0) {
        return;
    }
    
    CGRect frame1 = CGRectMake(history_X(self), history_Y(self) + history_H(self) + 1, history_W(self), 1);
    CGRect frame2 = CGRectMake(history_X(self), history_Y(self) + history_H(self) + 1, history_W(self), MIN(MAX_HEIGHT, ITEM_HEIGHT * history.count + CLEAR_BUTTON_HEIGHT));
    
    self.historyTableView.frame = frame1;
    
    [self.superview addSubview:self.historyTableView];
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.historyTableView.frame = frame2;
    }];
}

- (void)clearHistoryButtonClick:(UIButton *)button {
    [self clearHistory];
    [self hideHistroy];
}

- (void)hideHistroy {
    if (self.historyTableView.superview == nil) {
        return;
    }

    CGRect frame1 = CGRectMake(history_X(self), history_Y(self) + history_H(self) + 1, history_W(self), 1);
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.historyTableView.frame = frame1;
    } completion:^(BOOL finished) {
        [self.historyTableView removeFromSuperview];
    }];
}

- (void)clearHistory {
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    
    [def setObject:nil forKey:@"UITextField+JKHistory"];
    [def synchronize];
}


#pragma mark - tableview datasource
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    return [self loadHistroy].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITextFieldHistoryCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITextFieldHistoryCell"];
    }
    
    cell.textLabel.text = [self loadHistroy][indexPath.row];
    
    return cell;
}
#pragma clang diagnostic pop

#pragma mark - tableview delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section; {
    UIButton* clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearHistoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return clearButton;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return ITEM_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section; {
    return CLEAR_BUTTON_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    self.text = [self loadHistroy][indexPath.row];
    [self hideHistroy];
}

@end
