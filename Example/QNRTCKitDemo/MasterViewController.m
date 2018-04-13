//
//  MasterViewController.m
//  QNRTCKitDemo
//
//  Created by lawder on 2017/10/16.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SettingViewController.h"

@interface MasterViewController ()

@property NSArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"首页";
    self.objects = @[@"QNRTCKitDemo"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonClick:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)settingButtonClick:(id)sender
{
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *roomName = [userDefaults objectForKey:RoomNameKey];
    if (!roomName || [roomName isEqualToString:@""]) {
        [self showAlertWithMessage:@"请先点击右上角设置按钮设置您的房间名"];
        return;
    }
    
    if (indexPath.row == 0) {
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        detailViewController.roomName = roomName;
        [self.navigationController pushViewController:detailViewController animated:YES];
        return;
    }
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}


@end
