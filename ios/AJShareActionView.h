//
//  AJShareActionView.h
//  AiJia
//
//  Created by Tony.lee on 15/8/5.
//  Copyright (c) 2015年 AiJia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AJShareActionViewDelegate;


@protocol AJShareItemViewDelegate <NSObject>

@optional

- (void)itemBeClicked:(NSInteger)indx;

@end




@protocol AJShareActionViewDelegate <NSObject>

@optional

- (void)shareActionSheetSelect:(NSInteger)index;

@end



@interface AJShareItemView : UIView

@property (nonatomic, retain) UIImageView *imgView;

@property (nonatomic, retain) UILabel     *textLabel;

@property (nonatomic, weak)id<AJShareItemViewDelegate>delegate;

- (void)updataImgStr:(NSString *)imgStr andText:(NSString *)text;


@end

@interface AJShareActionView : UIView

@property (nonatomic, assign)id<AJShareActionViewDelegate>delegate;

+(AJShareActionView *)sharedInstance;
- (void)calloutShareView_1:(UIView *)vw andTarget:(id)target;


@end


