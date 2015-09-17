//
//  DVSBatchRequestAgent.m
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/5/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import "DVSBatchRequestAgent.h"

@interface DVSBatchRequestAgent ()
@property (nonatomic,strong) NSMutableArray *mutableRequestArray;
@end

@implementation DVSBatchRequestAgent

+ (DVSBatchRequestAgent *)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc]init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _mutableRequestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addBatchRequest:(DVSBatchRequest *)request {
    @synchronized(self) {
        [_mutableRequestArray addObject:request];
    }
}

- (void)removeBatchRequest:(DVSBatchRequest *)request {
    @synchronized(self) {
        [_mutableRequestArray removeObject:request];
    }
}

@end
