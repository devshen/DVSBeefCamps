//
//  ReformerData.h
//  SQ_AFNetworking
//
//  Created by Quan.Shen on 8/16/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseReformer.h"

extern NSString * const kPropertyListDataKeyID;
extern NSString * const kPropertyListDataKeyWho;
extern NSString * const kPropertyListDataKeyImageUrl;

@interface BeautyReformerData : BaseReformer <DVSReformerDataProtocol>

- (NSDictionary *)reformData:(NSDictionary *)data fromAPI:(DVSNetBaseRequest *)request;

@end
