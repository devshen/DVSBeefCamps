//
//  ReformerData.m
//  SQ_AFNetworking
//
//  Created by Quan.Shen on 8/16/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import "BeautyReformerData.h"
#import "DVSNetBaseRequest.h"

NSString * const kPropertyListDataKeyID = @"kPropertyListDataKeyID";
NSString * const kPropertyListDataKeyWho = @"kPropertyListDataKeyWho";
NSString * const kPropertyListDataKeyImageUrl = @"kPropertyListDataKeyImageUrl";

NSString * const jsonDataError = @"error";
NSString * const jsonDataResults = @"results";
NSString * const jsonDataResultCreatedAt = @"createdAt";
NSString * const jsonDataResultDesc = @"desc";
NSString * const jsonDataResultObjectId = @"objectId";
NSString * const jsonDataResultType = @"type";
NSString * const jsonDataResultUpdatedAt = @"updatedAt";
NSString * const jsonDataResultUrl = @"url";
NSString * const jsonDataResultPublishedAt = @"publishedAt";
NSString * const jsonDataResultUsed = @"used";
NSString * const jsonDataResultWho = @"who";


@implementation BeautyReformerData

- (NSDictionary *)reformData:(NSDictionary *)data fromAPI:(DVSNetBaseRequest *)request {
    NSLog(@" api原始数据 data %@",data);
    if ([data[jsonDataError] integerValue] != 0) {
        return @{@"error":data[jsonDataError]};
    }
    
    NSArray *results = data[jsonDataResults];
    
    __block NSMutableArray * resultsArr = [NSMutableArray new];
    
    [results enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = @{
                              kPropertyListDataKeyID:obj[jsonDataResultObjectId],
                              kPropertyListDataKeyWho:obj[jsonDataResultWho],
                              kPropertyListDataKeyImageUrl:obj[jsonDataResultUrl]
                              };
        [resultsArr addObject:dic];
    }];
    
    return [resultsArr copy];
}

@end
