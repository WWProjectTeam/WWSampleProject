//
//  HTTPClient+Other.m
//  HospitalBed
//
//  Created by push on 15/9/6.
//  Copyright (c) 2015年 Suwang. All rights reserved.
//

#import "HTTPClient+Other.h"

@implementation HTTPClient (Other)

/*---------------衣优V-------------------*/

/// 首页列表
- (AFHTTPRequestOperation *)postClothesListType:(NSInteger)type index:(NSInteger)index WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    NSDictionary *paramDic = @{@"index":[NSNumber numberWithInteger:index],
                               @"type":[NSNumber numberWithInteger:type]};
    
    NSDictionary *param = @{@"json" : [paramDic JSONString] };
    ///POST请求
    return [self postPath:KClothesListURL
               parameters:param
               completion:completionBlock];
    
}


@end
