//
//  BaseReformer.m
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/5/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import "BaseReformer.h"

@interface BaseReformer ()
@property (nonatomic,weak) id<DVSReformerDataProtocol> child;
@end

@implementation BaseReformer

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(DVSReformerDataProtocol)]) {
            _child = (id<DVSReformerDataProtocol>)self;
        }
        else {
            NSAssert(NO, @"subclass must implement <protocol> DVSReformerDataProtocol");
        }
    }
    return self;
}

@end
