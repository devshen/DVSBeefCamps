//
//  DVSNetBaseRequst.h
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/4/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"
#import "DVSReformDataProtocol.h"

@class AFHTTPRequestOperation;

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);

typedef NS_ENUM(NSInteger , DVSRequstMethod) {
    DVSRequstMethodGet = 0,
    DVSRequstMethodPost,
    DVSRequstMethodHead,
    DVSRequstMethodPut,
    DVSRequestMethodDelete,
    DVSRequestMethodPatch
};

/*--------------------------------------------*/
/*!
 *  用于子类化APIRequest时用户配置
 */
@protocol DVSAPIRequest <NSObject>
@required
@property (nonatomic, strong) NSDictionary *requestArgument;
- (NSString *)apiMethodName;
- (DVSRequstMethod) requestMethod;
@optional
- (BOOL) isCache;///<是否缓存
- (NSTimeInterval) requestTimeoutInterval;///<超时时间
- (AFConstructingBlock)constructingBodyBlock;///<上传数据block
- (id)responseProcess;///<response处理
@end

@class DVSNetBaseRequest;
/*--------------------------------------------*/
/*!
 *  请求完成或者失败的delegate
 */
@protocol DVSRequestDelegate <NSObject>
- (void)requestDidSuccess:(DVSNetBaseRequest *)request;
- (void)requestDidFailed:(DVSNetBaseRequest *)request;
@end

/*--------------------------------------------*/
/*!
 *  请求AOP
 */
@protocol DVSRequestAccessory <NSObject>
@optional
- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;
@end

/*--------------------------------------------*/
/*!
 *  基本请求类型，用作基类
 */
@interface DVSNetBaseRequest : NSObject
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;
@property (nonatomic, weak) id<DVSRequestDelegate> delegate;
@property (nonatomic, weak, readonly) id<DVSAPIRequest> child;
@property (nonatomic, strong, readonly) id responseJSONObject;
@property (nonatomic, strong, readonly) id cacheJson;
@property (nonatomic, readonly) NSArray *requestAccessories;
@property (nonatomic, copy) void (^successCompletionBlock)(DVSNetBaseRequest *);
@property (nonatomic, copy) void (^failureCompletionBlock)(DVSNetBaseRequest *);
- (void)start;
- (void)stop;
- (void)startWithCompletionBlockWithSuccess:(void (^)(id request))success
                                    failure:(void (^)(id request))failure;
- (void)clearCompletionBlock;
- (BOOL)statusCodeValidator;
- (void)addAccessory:(id<DVSRequestAccessory>)accessory;
- (id)fetchDataWithReformer:(id<DVSReformerDataProtocol>)reformer;
@end

@interface DVSNetBaseRequest (RequestAccessory)
- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;
@end