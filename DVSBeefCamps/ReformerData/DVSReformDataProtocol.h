//
//  DVSReformDataProtocol.h
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/5/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVSNetBaseRequest;
@protocol DVSReformerDataProtocol <NSObject>
- (NSDictionary *)reformData:(NSDictionary *)data fromAPI:(DVSNetBaseRequest *)request;
@end