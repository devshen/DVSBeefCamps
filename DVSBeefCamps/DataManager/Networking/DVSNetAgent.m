//
//  DVSNetAgent.m
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/5/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import "DVSNetAgent.h"
#import <AFNetworking/AFNetworking.h>
#import "DVSNetConfig.h"
#import "DVSNetBaseRequest.h"

@interface DVSNetAgent ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) NSMutableDictionary *requestsRecord;
@property (nonatomic, strong) DVSNetConfig *config;
@end

@implementation DVSNetAgent

+ (DVSNetAgent *)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc]init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _config = [DVSNetConfig sharedInstance];
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        _requestsRecord = [NSMutableDictionary dictionary];

    }
    return self;
}

- (void)addRequest:(DVSNetBaseRequest *)request {
    NSString *url = [self buildRequestUrl:request];
    if ([url hasPrefix:@"https"]) {
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
        self.manager.securityPolicy = securityPolicy;
    }
    
    if ([request.child respondsToSelector:@selector(requestTimeoutInterval)]) {
        self.manager.requestSerializer.timeoutInterval = [request.child requestTimeoutInterval];
    }
    
    NSDictionary *argument = [request.child requestArgument];
    DVSRequstMethod requsetMethod = [request.child requestMethod];
    
    switch (requsetMethod) {
        case DVSRequstMethodGet: {
            request.requestOperation = [self.manager GET:url parameters:argument success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        }
            break;
        case DVSRequstMethodPost: {
            if ([request.child respondsToSelector:@selector(constructingBodyBlock)] && [request.child constructingBodyBlock]) {
                request.requestOperation = [self.manager POST:url parameters:argument constructingBodyWithBlock:[request.child constructingBodyBlock] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self handleRequestResult:operation];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation];
                }];
            }
            else{
                request.requestOperation = [self.manager POST:url parameters:argument success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self handleRequestResult:operation];
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation];
                }];
            }
        }
            break;
        case DVSRequstMethodHead: {
            request.requestOperation = [self.manager HEAD:url parameters:argument success:^(AFHTTPRequestOperation *operation) {
                [self handleRequestResult:operation];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        }
            break;
        case DVSRequstMethodPut: {
            request.requestOperation = [_manager PUT:url parameters:argument success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        }
            break;
        case DVSRequestMethodDelete: {
            request.requestOperation = [_manager DELETE:url parameters:argument success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        }
            break;
        case DVSRequestMethodPatch: {
            request.requestOperation = [_manager PATCH:url parameters:argument success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        }
            break;
        default: {
            
        }
            break;
    }
    [self addOperation:request];
    
}

- (void)handleRequestResult:(AFHTTPRequestOperation *)operation {
    NSString *key = [self requestHashKey:operation];
    DVSNetBaseRequest *request = _requestsRecord[key];
    NSLog(@"URL:%@", request.requestOperation.request.URL);
    if (request) {
        BOOL success = [self checkResult:request];
        if (success) {
            [request toggleAccessoriesWillStopCallBack];
            if (([request.child respondsToSelector:@selector(isCache)] && [request.child isCache])) {
                //更新缓存
            }
            if ([request.delegate respondsToSelector:@selector(requestDidSuccess:)]) {
                [request.delegate requestDidSuccess:request];
            }
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];
        }
        else {
            [request toggleAccessoriesWillStopCallBack];
            if ([request.delegate respondsToSelector:@selector(requestDidFailed:)]) {
                [request.delegate requestDidFailed:request];
            }
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];
        }
        
    }
    [self removeOperation:operation];
    [request clearCompletionBlock];
}

- (void)addOperation:(DVSNetBaseRequest *)request {
    if (request.requestOperation != nil) {
        NSString *key = [self requestHashKey:request.requestOperation];
        @synchronized(self) {
            self.requestsRecord[key] = request;
        }
    }
}

- (void)cancelRequest:(DVSNetBaseRequest *)request {
    [request.requestOperation cancel];
    [self removeOperation:request.requestOperation];
    [request clearCompletionBlock];
}

- (void)removeOperation:(AFHTTPRequestOperation *)operation {
    NSString *key = [self requestHashKey:operation];
    @synchronized(self) {
        [_requestsRecord removeObjectForKey:key];
    }
}

- (BOOL)checkResult:(DVSNetBaseRequest *)request {
    BOOL result = [request statusCodeValidator];
    if (!result) {
        return result;
    }
    return result;
}

- (NSString *)buildRequestUrl:(DVSNetBaseRequest *)request {
    NSString *baseUrl = self.config.mainBaseUrl;
    if (baseUrl) {
        return [baseUrl stringByAppendingString:[request.child apiMethodName]];
    }
    return [request.child apiMethodName];
}

- (NSString *)requestHashKey:(id)object {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[object hash]];
    return key;
}

@end
