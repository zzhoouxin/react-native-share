//
//  AJRCTShare.m
//  AJShare
//
//  Created by 朱素育 on 2019/7/29.
//  Copyright © 2019 朱素育. All rights reserved.
//

#import "AJRCTShare.h"
#import "AJShare.h"

@implementation AJRCTShare
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();

#pragma mark - share
/**
 *  ////分享
 *
 *  @param NSInteger
 *  @param NSString  string参数为 分享id
 */
RCT_EXPORT_METHOD(share:(NSInteger)shareType albumId:(NSString *)param)
{
    dispatch_async([self methodQueue], ^{
        AJShareModel *shareContent = [self constructShareData:param];
        [[AJShare sharedShare] shareContentTo:shareType-1 andContent:shareContent];
    });
}

//分享微信、朋友圈带回调
RCT_EXPORT_METHOD(share:(NSInteger)shareType albumId:(NSString *)param callBack:(RCTResponseSenderBlock)callback)
{
    dispatch_async([self methodQueue], ^{
        AJShareModel *shareContent = [self constructShareData:param];
        [[AJShare sharedShare] shareContentTo:shareType-1 andContent:shareContent result:^(BOOL success) {
            callback(@[@(success)]);
        }];
    });
    
}

- (AJShareModel *)constructShareData:(NSString *)parameterString
{
    NSDictionary *dict = [self jsonToDic:parameterString];
    if(dict!= nil && [dict isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    AJShareModel *nativeH5SharedContent = [[AJShareModel alloc] init];
    NSString *urlStr       = dict[@"mUrl"];
    nativeH5SharedContent.webUrl = urlStr;
    NSDictionary *subDict = dict[@"shareContent"];
    nativeH5SharedContent.desc  = subDict[@"desc"];
    nativeH5SharedContent.title = subDict[@"title"];
    nativeH5SharedContent.imageUrl = subDict[@"url"];
    
    return nativeH5SharedContent;
}

// 微信分享pdf文件，不支持朋友圈，文件大于10m不调用此事件由rn控制
RCT_EXPORT_METHOD(showShareView:(NSString *)filePath title:(NSString *)title)
{
    dispatch_async([self methodQueue], ^{
        [[AJShare sharedShare] weixinSharePDFWithPath:filePath title:title];
    });

}

// 微信分享图片
RCT_EXPORT_METHOD(shareImageToFriend:(NSString *)filePath)
{
    dispatch_async([self methodQueue], ^{
        [[AJShare sharedShare] weixinShareImageWithPath:filePath];
    });
}


- (NSDictionary *)jsonToDic:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
