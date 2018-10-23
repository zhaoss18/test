//
//  HLHealthAdviceDescWebView.h
//  LianLianApp2
//
//  Created by zss on 2018/3/30.
//  Copyright © 2018年 zss. All rights reserved.
//
#import <UIKit/UIKit.h>
@class HLHealthAdviceDetailModel;
@class HLHealthAdviceTableCell;


@interface HLHealthAdviceDescWebView:UIView
@property (strong,nonatomic) UIImageView *iv;
@property (strong,nonatomic) UIWebView *webView;

@property (assign,nonatomic) CGRect lastDisplayRect;
@property (strong,nonatomic) UIView *superDisplayCell;
@property (strong,nonatomic)  HLHealthAdviceDetailModel *detailModel;
- (void)requestWebview;
- (void)initWithUrlStr:(NSString*)utrlStr image:(UIImage*)image;
+ (void)joinAnimadetailObj:(HLHealthAdviceDetailModel*)detailObj cell:(HLHealthAdviceTableCell*)cell;
- (void)layoutUI;
@end

