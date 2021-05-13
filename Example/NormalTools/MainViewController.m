//
//  NTViewController.m
//  NormalTools
//
//  Created by Fengzee on 05/27/2020.
//  Copyright (c) 2020 Fengzee. All rights reserved.
//

#import "MainViewController.h"
#import <objc/runtime.h>

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) NSArray *items;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.items = @[
        @{@"title":@"Ripples",@"className":@"RipplesViewController"},
        @{@"title":@"Player",@"className":@"ZMPlayerController"}
    ];
    
    [self.mainTableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.items[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class class = object_isClass(self.items[indexPath.row][@"className"]) ? self.items[indexPath.row][@"className"] : NSClassFromString(self.items[indexPath.row][@"className"]);
    NSString *classNme = NSStringFromClass(class);
    UIViewController *testVc = [[class alloc] init];
    testVc.title = self.items[indexPath.row][@"title"];
    if ([classNme isEqualToString:@"ZMPlayerController"]) {
        ZMPlayerController *vc = (ZMPlayerController *)testVc;
        vc.videoUrl = @"https://devstreaming-cdn.apple.com/videos/wwdc/2020/10690/3/BEEE0B3F-1BD4-4333-BBB2-6B0999D91F6B/master.m3u8";
    }
    [self.navigationController pushViewController:testVc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
