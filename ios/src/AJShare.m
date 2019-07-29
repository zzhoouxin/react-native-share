//
//  AJShare.m
//  AJShare
//
//  Created by 朱素育 on 2019/7/26.
//  Copyright © 2019 朱素育. All rights reserved.
//

#import "AJShare.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface AJShare ()

@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, copy) shareResult shareResultBlock;
@property (nonatomic, copy) NSString *wbToken;
@property (nonatomic, copy) NSString *tencentAppId;
@property (nonatomic, copy) NSString *wechatAppId;
@end

@implementation AJShare
- (TencentOAuth *)tencentOAuth {
    if (nil == _tencentOAuth && nil != self.tencentAppId) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:self.tencentAppId
                                                andDelegate:nil];
    }
    return _tencentOAuth;
}

+ (AJShare *)sharedShare
{
    static AJShare *_sharedShare = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedShare = [[AJShare alloc] init];
    });
    
    return _sharedShare;
}

- (void)registerWechat:(NSString *)appId {
    [WXApi registerApp:appId];
}

- (void)registerTencent:(NSString *)appId {
    self.tencentAppId = appId;
}

- (void)registerWebo:(NSString *)appId {
    [WeiboSDK registerApp:appId];
}

#pragma mark - public methods
- (void)shareContentTo:(SHARE_CATEGORY)way andContent:(AJShareModel *)content result:(void(^)(BOOL success))block
{
    self.shareResultBlock = block;
    
    [self shareContentTo:way andContent:content];
}

- (void)shareContentTo:(SHARE_CATEGORY)way andContent:(AJShareModel *)content
{
    NSString *webUrl             = content.webUrl;
//    AJShareSubContent *subCont = content.shareContent;
    NSString *tit              = content.title;
    NSString *description      = content.desc;
    NSString *imageUrl   = content.imageUrl;
    
    if(!webUrl)
        webUrl = imageUrl;
    
    if(tit == nil || webUrl == nil || description == nil || [description isKindOfClass:[NSNull class]])
    {
        return;
    }
    
    if(way == SHARE_CATEGORY_WEIXIN_CHAT)
    {
        [self weixinShareWithTitle:tit description:description webpageUrl:webUrl logoURL:imageUrl scene:WXSceneSession];
    }
    else if(way == SHARE_CATEGORY_WEIXIN_FRIENDS)
    {
        [self weixinShareWithTitle:tit description:description webpageUrl:webUrl logoURL:imageUrl scene:WXSceneTimeline];
    }
    else if(way == SHARE_CATEGORY_TECENT_QQ)
    {
        [self tencentShareWithTitle:tit linkURL:[NSURL URLWithString:webUrl] description:description previewImageURL:[NSURL URLWithString:imageUrl]];
    }
    else
    {
        [self sinaShareWithObject:content];
        //        [self ssoUserLog];
    }
}

- (void)ssoUserLog
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI         = @"";
    request.scope               = @"all";
    request.userInfo            = @{@"SSO_From": @"AIJIA"};
    [WeiboSDK sendRequest:request];
}

#pragma mark --- sina
- (void)sinaShareWithObject:(AJShareModel *)cont
{
    if(self.wbToken)
    {
        [self ssoUserLog];
    }
    else
    {
        WBAuthorizeRequest *authRequest                     = [WBAuthorizeRequest request];
        authRequest.redirectURI                             = @"";//KRedirectURI1;
        authRequest.scope                                   = @"all";
        
        WBSendMessageToWeiboRequest *request                = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare:cont] authInfo:authRequest access_token:self.wbToken];
        request.userInfo                                    = @{@"ShareMessageFrom": @"AIJIA"};
        request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:request];
    }
}

- (WBMessageObject *)messageToShare:(AJShareModel *)content
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text             = content.desc;
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID         = @"identifier1";
    webpage.title            = content.title;
    webpage.description      = content.desc;
    
//    [[CXImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:content.imageUrl] image:^(UIImage *img, NSError *error) {
//        webpage.thumbnailData    = UIImageJPEGRepresentation(img, 1.0f);
//    }];
    webpage.webpageUrl       = content.webUrl;
    message.mediaObject      = webpage;
    
    return message;
}

- (void)receiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken) {
            self.wbToken = accessToken;
        }
        //        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        //        if (userID) {
        //            self.wbCurrentUserID = userID;
        //        }
        
    } else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];

        self.wbToken = [(WBAuthorizeResponse *)response accessToken];
        //        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
    }
}

- (BOOL)HandleTencentOpenURL:(NSURL *)url {
    return [TencentOAuth HandleOpenURL:url];
}

#pragma mark Private
- (NSString *)tencentSendErrorMsgWithSendResult:(QQApiSendResultCode)sendResult
{
    NSString *sendErrorMsg = nil;
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED: {
            sendErrorMsg        = @"App未注册";
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID: {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            sendErrorMsg        = @"发送参数错误";
            break;
        }
        case EQQAPIQQNOTINSTALLED: {
            sendErrorMsg        = @"未安装手机QQ";
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI: {
            sendErrorMsg        = @"API接口不支持";
            break;
        }
        case EQQAPISENDFAILD: {
            sendErrorMsg        = @"发送失败";
            break;
        }
        default:
        {
            break;
        }
    }
    
    return sendErrorMsg;
}

#pragma mark Tencent
/**
 腾讯分享
 @param title 分享内容标题
 @param linkURL 分享内容链接url
 @param description 分享内容的描述
 @param previewURL logo url
 */
- (void)tencentShareWithTitle:(NSString *)title linkURL:(NSURL *)linkURL  description:(NSString*)description previewImageURL:(NSURL*)previewURL
{
    if (nil == self.tencentOAuth) return;
    
    if (![QQApiInterface isQQInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装'手机QQ'" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    QQApiNewsObject *newsObj = nil;
    
    if (previewURL) {
        newsObj = [QQApiNewsObject objectWithURL:linkURL
                                           title:title
                                     description:description
                                 previewImageURL:previewURL];
    }
    else {
        newsObj = [QQApiNewsObject objectWithURL:linkURL title:title description:description previewImageData:UIImageJPEGRepresentation([UIImage imageNamed:@"AppIcon60x60"], 1.0F)];
    }
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    NSString *sentErrorMsg = [self tencentSendErrorMsgWithSendResult:sent];
    
    if (sentErrorMsg) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:sentErrorMsg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark Weixin
- (void)weixinShareWithContent:(NSString *)content scene:(enum WXScene)scene
{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装'微信'" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = content;
    req.bText = YES;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

- (void)weixinShareWithTitle:(NSString *)title thumbImage:(UIImage *)thumbImage image:(UIImage *)image scene:(enum WXScene)scene
{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装'微信'" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbImage];
    message.title = title;
    
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(image, 1.0F);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

/**
 微信分享'链接内容'
 @param title 分享内容标题
 @param description 分享内容的描述
 @param webpageUrl 分享内容链接url
 @param logoURL logo url
 @param scene 分享到的场景（好友、朋友圈、收藏）
 */
- (BOOL)weixinShareWithTitle:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl logoURL:(NSString *)logoURL scene:(enum WXScene)scene
{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装'微信'" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    
    __block BOOL isSend = NO;
    
    if ([logoURL length] > 0) {
        [self.delegate downLoadImageUrl:logoURL complete:^(UIImage *image, NSError *error) {
            NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
            if (([imgData length] / 1024.0f) <= 32.0f) {
                [message setThumbImage:image];
            }
            else {
                UIImage *img = [self.delegate scaleImage:image toSize:CGSizeMake(100, 100)];
                [message setThumbImage:img];
            }
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = webpageUrl;
            
            message.mediaObject = ext;
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = scene;
            
            isSend = [WXApi sendReq:req];
        }];
    }
    else {
        [message setThumbImage:[UIImage imageNamed:@"AppIcon60x60"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = webpageUrl;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        
        isSend = [WXApi sendReq:req];
    }
    
    return isSend;
}

- (BOOL)weixinSharePDFWithPath:(NSString *)filePath title:(NSString *)title
{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装'微信'" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    WXFileObject *fileObject = [WXFileObject object];
    fileObject.fileData = data;
    fileObject.fileExtension = @"pdf";
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = fileObject;
    message.title = [NSString stringWithFormat:@"%@.pdf",title];
    message.description = @"";
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    return [WXApi sendReq:req];
}

-(BOOL)weixinShareImageWithPath:(NSString *)filePath
{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装'微信'" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = data;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = imageObject;
    message.description = @"";
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    return [WXApi sendReq:req];
}

#pragma mark 微信分享到朋友圈成功后的处理
- (void)handleWithResp:(SendMessageToWXResp *)sendMessageToWXResp
{
    if (self.shareResultBlock) {
        BOOL success = (sendMessageToWXResp.errCode == 0) ? YES : NO;
        self.shareResultBlock(success);
        
        self.shareResultBlock = nil;
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    [self prese]
}

@end
