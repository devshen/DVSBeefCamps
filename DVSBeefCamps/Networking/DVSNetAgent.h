//
//  DVSNetAgent.h
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/5/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVSNetBaseRequest;
@interface DVSNetAgent : NSObject

+ (DVSNetAgent *)sharedInstance;

- (void)addRequest:(DVSNetBaseRequest *)request;
- (void)cancelRequest:(DVSNetBaseRequest *)request;
@end
