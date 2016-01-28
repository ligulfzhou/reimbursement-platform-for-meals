//
//  Canfei.m
//  dingcan
//
//  Created by ligulfzhou on 1/26/16.
//  Copyright © 2016 ligulfzhou. All rights reserved.
//

#import "Canfei.h"

@implementation Canfei

-(instancetype) initWithDate:(NSString *)date andCanfei:(NSString *)canfei
{
    self= [super init];
    if (self) {
        self.date = date;
        self.canfei = canfei;
    }
    return self;
}

@end
