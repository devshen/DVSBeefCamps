//
//  DVSNetBatchRequst.h
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/5/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DVSBatchRequest;
@protocol DVSNetBatchRequestDelegate <NSObject>

- (void)batchRequestFinished:(DVSBatchRequest *)batchRequest;
- (void)batchRequestFailed:(DVSBatchRequest *)batchRequest;

@end

/*!
 *  批量处理请求类
 */
@interface DVSBatchRequest : NSObject

@property (nonatomic, weak) id<DVSNetBatchRequestDelegate> delegate;
@property (nonatomic, copy) void(^successCompletionBlock)(DVSBatchRequest *);
@property (nonatomic, copy) void(^failureCompletionBlock)(DVSBatchRequest *);
@property (nonatomic, readonly) NSArray *requestArray;
@property (nonatomic, readonly) NSArray *requestAccessories;

- (instancetype)initWithRequestArray:(NSArray *)requestArray;
- (void)start;
- (void)stop;
- (void)startWithCompletionBlockWithSuccess:(void(^)(DVSBatchRequest *batchRequest))success
                                    failure:(void(^)(DVSBatchRequest *batchRequest))failure;
- (void)clearCompletionBlock;

@end

@interface DVSBatchRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;

@end