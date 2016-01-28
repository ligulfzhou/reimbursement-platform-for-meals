//
//  ViewController.m
//  dingcan
//
//  Created by ligulfzhou on 1/25/16.
//  Copyright © 2016 ligulfzhou. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPSessionManager+Util.h"
#import <AFNetworking.h>
#import "CanfeiViewControll.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(self.view.center.x, self.view.center.y, self.view.center.x + 20, self.view.center.y + 20);
    [button setTitle:@"Click ME!" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
}

-(void) buttonClicked: (id)sender{
    NSLog(@"you click the button");
    [[AFHTTPSessionManager manager] POST:@"http://192.168.1.100:8888/api/login"
                              parameters:@{@"mobile": @"15990187931", @"password": @"187931"}
                                progress:^(NSProgress * _Nonnull uploadProgress) {
                                    NSLog(@"progress...........");
                                }
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                     [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"user"][@"token"]  forKey:@"token"];
                                     [self logUserToken];
                                     
                                     CanfeiViewControll *vc = [CanfeiViewControll new];
                                     [self.navigationController pushViewController:vc animated:YES];
                                     
                                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     NSLog(@"%@", error);
                                 }];
}


-(void)logUserToken
{
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"token"]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
