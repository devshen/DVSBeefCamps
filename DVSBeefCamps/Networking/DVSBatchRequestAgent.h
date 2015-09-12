//
//  DVSBatchRequestAgent.h
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/5/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVSBatchRequest;
@interface DVSBatchRequestAgent : NSObject

+ (DVSBatchRequestAgent *)sharedInstance;

- (void)addBatchRequest:(DVSBatchRequest *)request;
- (void)removeBatchRequest:(DVSBatchRequest *)request;

@end
