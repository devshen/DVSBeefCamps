//
//  ViewController.m
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/4/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import "ViewController.h"
#import "DVSNetworking.h"
#import "BeautyReformerData.h"

@interface API1 : DVSNetBaseRequest <DVSAPIRequest>
@property (nonatomic, strong) NSDictionary *requestArgument;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger page;
@end
@implementation API1

- (NSString *)apiMethodName {
    return [NSString stringWithFormat:@"/iOS/%ld/%ld",self.number,self.page];
}

- (DVSRequstMethod) requestMethod {
    return DVSRequstMethodGet;
}

@end

@interface API2 : DVSNetBaseRequest <DVSAPIRequest>
@property (nonatomic, strong) NSDictionary *requestArgument;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger page;
@end
@implementation API2

- (NSString *)apiMethodName {
    return [NSString stringWithFormat:@"/Android/%ld/%ld",self.number,self.page];
}

- (DVSRequstMethod) requestMethod {
    return DVSRequstMethodGet;
}

@end

/*-----------------------------------------*/
@interface ViewController () <DVSRequestDelegate>
@property (nonatomic,strong) id<DVSReformerDataProtocol> mainReform;
@property (nonatomic,strong) id<DVSReformerDataProtocol> otherReform;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainReform = [BeautyReformerData new];
    self.otherReform = [BeautyReformerData new];
    
    API1 *api1 = [[API1 alloc]init];
    api1.number = 1;
    api1.page = 1;
    api1.delegate = self;
    [api1 start];
    
    API2 *api2 = [[API2 alloc]init];
    api2.number = 5;
    api2.page = 2;
    api2.delegate = self;
    [api2 start];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 一个api数据给多个view使用 或者 多个api在此页面使用
- (void)requestDidSuccess:(DVSNetBaseRequest *)request {
    
    if ([request isKindOfClass:[API1 class]]) {
        NSDictionary *reformedXXXData = [request fetchDataWithReformer:self.mainReform];
        NSLog(@"转换后reformedXXXData=%@",reformedXXXData);
        // view1 用xxx ios数据
        
    } else if ([request isKindOfClass:[API2 class]]) {
        NSDictionary *reformedYYYData = [request fetchDataWithReformer:self.otherReform];
        NSLog(@"转化后reformedYYYData=%@",reformedYYYData);
        // view2 用yyy android数据
    }

}

- (void)requestDidFailed:(DVSNetBaseRequest *)request {
    
}


@end


