//
//  DVSNetBatchRequst.m
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/5/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import "DVSBatchRequest.h"
#import "DVSNetBaseRequest.h"
#import "DVSBatchRequestAgent.h"

@interface DVSBatchRequest  () <DVSRequestDelegate>

@property (nonatomic) NSInteger finishedCount;
@property (nonatomic, strong) NSMutableArray *mutableBatchRequestAccessories;

@end

@implementation DVSBatchRequest

- (instancetype)initWithRequestArray:(NSArray *)requestArray {
    self = [super init];
    if (self) {
        _requestArray = [requestArray copy];
        _finishedCount = 0;
        for (DVSNetBaseRequest * req in _requestArray) {
            if (![req isKindOfClass:[DVSNetBaseRequest class]]) {
                NSAssert(NO,@"Error, request item must be DVSNetBaseRequest instance.");
                return nil;
            }
        }
    }
    return self;
}

- (void)start {
    if (_finishedCount > 0) {
        NSLog(@"Error! Batch request has already started.");
        return;
    }
    [[DVSBatchRequestAgent sharedInstance] addBatchRequest:self];
    [self toggleAccessoriesWillStartCallBack];
    for (DVSNetBaseRequest * req in _requestArray) {
        req.delegate = self;
        [req start];
    }
}

- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    _delegate = nil;
    [self clearRequest];
    [self toggleAccessoriesDidStopCallBack];
    [[DVSBatchRequestAgent sharedInstance] removeBatchRequest:self];

}

- (void)startWithCompletionBlockWithSuccess:(void (^)(DVSBatchRequest *))success
                                    failure:(void (^)(DVSBatchRequest *))failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];

}

- (void)setCompletionBlockWithSuccess:(void (^)(DVSBatchRequest *batchRequest))success
                              failure:(void (^)(DVSBatchRequest *batchRequest))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (NSArray *)requestAccessories {
    return [self.mutableBatchRequestAccessories copy];
}

- (void)dealloc {
    [self clearRequest];
}

#pragma DVSRequestDelegate

- (void)requestDidSuccess:(DVSNetBaseRequest *)request {
    _finishedCount++;
    
    if (_finishedCount == _requestArray.count) {
        
        [self toggleAccessoriesWillStopCallBack];
        if ([_delegate respondsToSelector:@selector(batchRequestFinished:)]) {
            [_delegate batchRequestFinished:self];
        }
        if (_successCompletionBlock) {
            _successCompletionBlock(self);
        }
        [self clearCompletionBlock];
        [self toggleAccessoriesDidStopCallBack];
    }
}

- (void)requestDidFailed:(DVSNetBaseRequest *)request {
    [self toggleAccessoriesWillStopCallBack];

    for (DVSNetBaseRequest *req in _requestArray) {
        [req stop];
    }

    if ([_delegate respondsToSelector:@selector(batchRequestFailed:)]) {
        [_delegate batchRequestFailed:self];
    }
    if (_failureCompletionBlock) {
        _failureCompletionBlock(self);
    }

    [self clearCompletionBlock];
    
    [self toggleAccessoriesDidStopCallBack];
    [[DVSBatchRequestAgent sharedInstance] removeBatchRequest:self];

}

- (void)clearRequest {
    for (DVSNetBaseRequest * req in _requestArray) {
        [req stop];
    }
    [self clearCompletionBlock];
}

- (void)addAccessory:(id<DVSRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.mutableBatchRequestAccessories = [NSMutableArray array];
    }
    [self.mutableBatchRequestAccessories addObject:accessory];
}

@end

@implementation DVSBatchRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack {
    for (id<DVSRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStart:)]) {
            [accessory requestWillStart:self];
        }
    }
}

- (void)toggleAccessoriesWillStopCallBack {
    for (id<DVSRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestWillStop:)]) {
            [accessory requestWillStop:self];
        }
    }
}

- (void)toggleAccessoriesDidStopCallBack {
    for (id<DVSRequestAccessory> accessory in self.requestAccessories) {
        if ([accessory respondsToSelector:@selector(requestDidStop:)]) {
            [accessory requestDidStop:self];
        }
    }
}

@end
