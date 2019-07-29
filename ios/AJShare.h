//
//  AJShare.h
//  AJShare
//
//  Created by 朱素育 on 2019/7/26.
//  Copyright © 2019 朱素育. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiChatSDK/WXApi.h"
#import "libWeiboSDK/WeiboSDK.h"
#import "AJShareModel.h"

typedef void(^shareResult)(BOOL success);

typedef NS_ENUM(NSInteger, SHARE_CATEGORY) {
    
    SHARE_CATEGORY_WEIXIN_CHAT =0 ,
    SHARE_CATEGORY_WEIXIN_FRIENDS,
    SHARE_CATEGORY_TECENT_QQ,
    SHARE_CATEGORY_WEIBO_SINA,
};

@protocol AJShareDelegate <NSObject>


@required
/**
 下载图片

 @param imageUrl 图片链接
 @param completeBlock 下载完成后回调
 */
- (void)downLoadImageUrl:(NSString *)imageUrl complete:(void (^)(UIImage *image, NSError *error))completeBlock;


/**
 按要求尺寸拉伸或截取图片

 @param image 原始图片
 @param size 目标尺寸
 @return 目标图片
 */
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

@end


@interface AJShare : NSObject

@property (nonatomic, weak) id<AJShareDelegate> delegate;

+ (AJShare *)sharedShare;

- (void)registerWechat:(NSString *)appId;
- (void)registerTencent:(NSString *)appId;
- (void)registerWebo:(NSString *)appId;

#pragma mark Weixin
- (void)weixinShareWithTitle:(NSString *)title thumbImage:(UIImage *)thumbImage image:(UIImage *)image scene:(enum WXScene)scene;

- (BOOL)weixinSharePDFWithPath:(NSString *)filePath title:(NSString *)title;

- (BOOL)weixinShareImageWithPath:(NSString *)filePath;

#pragma mark 微信分享到朋友圈成功后的处理
- (void)handleWithResp:(SendMessageToWXResp *)sendMessageToWXResp;

#pragma mark 微博成功后的处理
- (void)receiveWeiboResponse:(WBBaseResponse *)response;

#pragma mark QQ成功后的处理
- (BOOL)HandleTencentOpenURL:(NSURL *)url;

- (void)shareContentTo:(SHARE_CATEGORY)way andContent:(AJShareModel *)content;

- (void)shareContentTo:(SHARE_CATEGORY)way andContent:(AJShareModel *)content result:(shareResult)block;

@end
