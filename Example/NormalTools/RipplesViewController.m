//
//  RipplesViewController.m
//  NormalTools_Example
//
//  Created by mac on 2021/5/13.
//  Copyright © 2021 Fengzee. All rights reserved.
//

#import "RipplesViewController.h"

@interface RipplesViewController ()

@property(nonatomic, strong)RipplesView *ripples;

@end

@implementation RipplesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.ripples = [[RipplesView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2.0, (SCREEN_HEIGHT-100)/2.0 - kNavBarHeight, 100, 100)];
    self.ripples.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ripples];
    [self.ripples startAnimation];
//    for (UIView *view in self.ripples.subviews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            [self.ripples bringSubviewToFront:view];
//        }
//    }
    
//    __weak typeof(self) weakSelf = self;
//    self.ripples.startEventHandle = ^(BOOL selected){
//        if (!selected) {
//            [weakSelf.ripples startAnimation];
//        }else{
//            [weakSelf.ripples stopAnimation];
//        }
//    };
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
