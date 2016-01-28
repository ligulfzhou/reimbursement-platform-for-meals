//
//  Canfei.h
//  dingcan
//
//  Created by ligulfzhou on 1/26/16.
//  Copyright © 2016 ligulfzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Canfei : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *canfei;

-(instancetype)initWithDate:(NSString *)date andCanfei:(NSString *) canfei;

@end
