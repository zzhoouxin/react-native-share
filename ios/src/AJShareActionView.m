//
//  AJShareActionView.m
//  AiJia
//
//  Created by Tony.lee on 15/8/5.
//  Copyright (c) 2015年 AiJia. All rights reserved.
//

#import "AJShareActionView.h"
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SCREEN_RECT  ([UIScreen mainScreen].bounds)
#define IsPortrait ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
#define kScreenWidth (IsPortrait ? MIN(SCREEN_RECT.size.width,SCREEN_RECT.size.height) : MAX(SCREEN_RECT.size.width, SCREEN_RECT.size.height))
#define kScreenHeight (IsPortrait ? MAX(SCREEN_RECT.size.width,SCREEN_RECT.size.height) : MIN(SCREEN_RECT.size.width, SCREEN_RECT.size.height))
#define iPhoneX (IsPortrait ? ((kScreenWidth == 375.0f && kScreenHeight == 812.0f) || (kScreenWidth == 414.0f && kScreenHeight == 896.0f)) : ((kScreenWidth == 812.0f && kScreenHeight == 375.0f) || (kScreenWidth == 896.0f && kScreenHeight == 414.0f)))
#define ACTION_HEIGHT (442/2 + 10)

static AJShareActionView *actionView = nil;

@interface AJShareActionView ()<AJShareItemViewDelegate>

@property (nonatomic, retain) UIView    *backView;

@property (nonatomic, retain) UIView    *coverView;

@end

@implementation AJShareActionView


+(AJShareActionView *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect fra = [UIScreen mainScreen].bounds;
        actionView = [[AJShareActionView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(fra), CGRectGetWidth(fra), ACTION_HEIGHT)];
    });
    return actionView;
}

- (void)calloutShareView_1:(UIView *)vw andTarget:(id)target
{
    CGRect fra = [UIScreen mainScreen].bounds;
    
    [actionView setDelegate:target];
    [vw addSubview:actionView];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [actionView setFrame:CGRectMake(0, CGRectGetHeight(fra)-ACTION_HEIGHT, CGRectGetWidth(fra), ACTION_HEIGHT)];
    }];
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(fra), CGRectGetHeight(fra))];
    [_coverView setBackgroundColor:[UIColor blackColor]];
    [_coverView setAlpha:0.80];
    [self.superview addSubview:_coverView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTap:)];
    [self.coverView addGestureRecognizer:tap];
    
    [self.superview bringSubviewToFront:actionView];
}


#pragma mark - private methods
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        NSArray *arr = @[@"微信",@"朋友圈",@"QQ"];
         NSArray *arr1 = @[@"weixinIcon",@"pengyouquanIcon",@"qqIcon"];
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), ACTION_HEIGHT)];
        
        [_backView setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
//        [self setAlpha:0.85];
        [self addSubview:_backView];
        
        
        UILabel *titLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(_backView.frame), 23)];
        [titLable setTextAlignment:NSTextAlignmentCenter];
        [titLable setText:@"分享"];
        [titLable setFont:[UIFont boldSystemFontOfSize:17.0]];
        [_backView addSubview:titLable];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 53, CGRectGetWidth(_backView.frame), 0.5)];
        [line setBackgroundColor:UIColorFromRGB(0xEEEEEE)];
        [_backView addSubview:line];
        
        __weak typeof(self) weakSelf = self;
        [arr enumerateObjectsUsingBlock:^(NSString *str, NSUInteger index, BOOL *stop){
        
            AJShareItemView *item = [[AJShareItemView alloc] initWithFrame:CGRectMake(CGRectGetWidth(weakSelf.backView.frame)/3*index, CGRectGetMaxY(line.frame), CGRectGetWidth(weakSelf.backView.frame)/3, CGRectGetHeight(weakSelf.backView.frame))];
            [item updataImgStr:arr1[index] andText:arr[index]];
            item.delegate = self;
            item.tag  = index;
            [weakSelf.backView addSubview:item];
        }];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_backView.frame)- 49.5 - (iPhoneX ? 10 : 0), CGRectGetWidth(_backView.frame), .5)];
        [line1 setBackgroundColor:UIColorFromRGB(0xEEEEEE)];
        [_backView addSubview:line1];

        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_backView.frame)-49 - (iPhoneX ? 10 : 0), CGRectGetWidth(_backView.frame), 49)];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTintColor:UIColorFromRGB(0x004BFF)];
        [btn setTitleColor:UIColorFromRGB(0x004BFF) forState:UIControlStateNormal];
        [btn setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
        [btn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)itemBeClicked:(NSInteger)indx;
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareActionSheetSelect:)])
    {
        [self.delegate shareActionSheetSelect:indx];
    }
    [self cancelButtonClicked:nil];
}

- (void)cancelButtonClicked:(id)sender
{
    CGRect fra = [UIScreen mainScreen].bounds;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        
        [self setFrame:CGRectMake(0, CGRectGetHeight(fra), CGRectGetWidth(fra), 323/2)];
        [weakSelf.coverView removeFromSuperview];
        [actionView removeFromSuperview];
    }];
}

- (void)coverViewTap:(UITapGestureRecognizer *)gesture
{
    [self cancelButtonClicked:nil];
}

@end


#pragma mark - AJShareItemView
@implementation AJShareItemView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title andImgStr:(NSString *)imgStr
{
    self = [self initWithFrame:frame];
    
    CGFloat widt = CGRectGetWidth(frame);
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((widt-51)/2, CGRectGetHeight(frame)/5, 51, 51)];
    [self addSubview:_imgView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake((widt-60)/2, CGRectGetMaxY(_imgView.frame)+10, 60, 21)];
    [self addSubview:_textLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped:)];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tap];
    
    return self;
}

- (void)itemTapped:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(itemBeClicked:)])
    {
        [self.delegate itemBeClicked:self.tag];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        CGFloat widt = CGRectGetWidth(frame);
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((widt-51)/2, CGRectGetHeight(frame)/10-3, 52, 52)];
        [self addSubview:_imgView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake((widt-70)/2, CGRectGetMaxY(_imgView.frame)+10, 70, 21)];
        [_textLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [_textLabel setTextColor:UIColorFromRGB(0x393939)];
        [self addSubview:_textLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped:)];
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)updataImgStr:(NSString *)imgStr andText:(NSString *)text
{
    [_imgView setImage:[UIImage imageNamed:imgStr]];
    [_textLabel setText:text];
}

@end
