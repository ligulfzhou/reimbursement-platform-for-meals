//
//  CanfeiViewControll.m
//  dingcan
//
//  Created by ligulfzhou on 1/28/16.
//  Copyright © 2016 ligulfzhou. All rights reserved.
//

#import "CanfeiViewControll.h"
#import "AFHTTPSessionManager+Util.h"

@interface CanfeiViewControll()

@property (nonatomic, strong) NSArray *canfeis;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CanfeiViewControll


-(void)viewDidLoad
{
    [super viewDidLoad];
    _canfeis = @[];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
//    [_tableView reloadData];
    
    [self getCanfei];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_canfeis count];
}


-(void)getCanfei
{
//    if (_canfeis) {
//        return _canfeis;
//    }
//    NSMutableArray *canfei = [[NSMutableArray alloc] init];
//    __block NSMutableArray *canfeisssss = [[NSMutableArray alloc] init];
    
    [[AFHTTPSessionManager ApiManager] GET:@"http://192.168.1.100:8888/api/statistics"
                            parameters:@{@"flag": @0}
                               progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                {
                                    _canfeis = responseObject[@"statistics"];
                                    
                                    NSLog(@"caifei:   %@", _canfeis);
                                    [_tableView reloadData];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    NSLog(@"%@", error);
                                }];
//    return canfeisssss;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [[_canfeis objectAtIndex:indexPath.row] valueForKey:@"month"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[_canfeis objectAtIndex:indexPath.row] valueForKey:@"money"]];

//    cell.textLabel.text = [_canfeis objectAtIndex:indexPath.row][@"month"];
//    cell.detailTextLabel.text = [_canfeis objectAtIndex:indexPath.row][@"money"];
    return cell;
}

@end
