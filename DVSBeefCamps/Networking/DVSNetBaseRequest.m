//
//  DVSNetBaseRequst.m
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/4/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import "DVSNetBaseRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "DVSNetConfig.h"
#import "DVSNetAgent.h"
#import "DVSNetProxy.h"

@interface DVSNetBaseRequest ()

@property (nonatomic, strong) id cacheJson;
@property (nonatomic, strong) id responseJSONObject;
@property (nonatomic, weak) id<DVSAPIRequest> child;
@property (nonatomic, strong) NSMutableArray *mutableRequestAccessories;
@property (nonatomic, strong) DVSNetConfig *config;

@end

@implementation DVSNetBaseRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(DVSAPIRequest)]) {
            _child = (id<DVSAPIRequest>)self;
        }
        else {
            NSAssert(NO, @"subclass must implement <protocol> DVSAPIRequest");
        }
        _config = [DVSNetConfig sharedInstance];
    }
    return self;
}

- (void)start{
    [self toggleAccessoriesWillStartCallBack];
    [[DVSNetAgent sharedInstance] addRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(id request))success
                                    failure:(void (^)(id request))failure{
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    [self start];
}

- (id)responseJSONObject{
    return self.requestOperation.responseObject;
}

- (NSInteger)responseStatusCode{
    return self.requestOperation.response.statusCode;
}

- (id)cacheJson{
    return _cacheJson;
}

- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[DVSNetAgent sharedInstance] cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <=299) {
        return YES;
    } else {
        return NO;
    }
}

- (void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (id)fetchDataWithReformer:(id<DVSReformerDataProtocol>)reformer
{
    if (reformer == nil) {
        return self.responseJSONObject;
    } else {
        return [reformer reformData:self.responseJSONObject fromAPI:self];
    }
}

- (NSArray *)requestAccessories {
    return [self.mutableRequestAccessories copy];
}

#pragma mark - Request Accessoies

- (void)addAccessory:(id<DVSRequestAccessory>)accessory {
    if (!self.mutableRequestAccessories) {
        self.mutableRequestAccessories = [NSMutableArray array];
    }
    [self.mutableRequestAccessories addObject:accessory];
}

@end

@implementation DVSNetBaseRequest (RequestAccessory)

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