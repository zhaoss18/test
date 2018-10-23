//
//  HLHealthAdviceDescWebView.m
//  LianLianApp2
//
//  Created by zss on 2018/3/30.
//  Copyright © 2018年 zss. All rights reserved.
//

#import "HLHealthAdviceDescWebView.h"
#import "HLHealthAdviceModel.h"
#import "HLHealthAdviceTableCell.h"
#import <YYKit/YYKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageCompat.h>
#import "hDefine.h"
@interface HLHealthAdviceDescWebView()<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (copy,nonatomic) UIImage *image;
@property (copy,nonatomic) NSString *urlStr;
@property (strong,nonatomic) UIScrollView *scrollview;

@property (strong,nonatomic) UILabel *webViewTitleLabel;
@property (strong,nonatomic) UIImageView *jb;
@property (strong,nonatomic) UIButton *closetBtn;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGPoint draggingOriginPoint;
@property (nonatomic,assign) BOOL isClose;
@end
@implementation HLHealthAdviceDescWebView
- (void)layoutUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.iv];
    [self addSubview:self.webView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"mangerplanX.png"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    button.frame =CGRectMake(kFullScreenWidth-40-28, kDevice_Is_iPhoneX?24:0, 28+40, 28+40);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.iv addSubview:button];
    self.iv.userInteractionEnabled = YES;
    self.closetBtn = button;
    
    self.webViewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35+(kDevice_Is_iPhoneX?24:0), kFullScreenWidth-20-68-5, 22)];
    self.webViewTitleLabel.textColor = [UIColor blackColor];
    self.webViewTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.webViewTitleLabel.text = self.detailModel.taskName;
    [self.iv addSubview:self.webViewTitleLabel];
    [self bringSubviewToFront:self.webViewTitleLabel];
    
}


- (void)requestWebview
{
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}
- (void)buttonClick
{
    if (self.isClose==YES) {
        return;
    }
    self.isClose = YES;
    self.scrollview.contentSize = CGSizeMake(0, 0);
    UIImage *image = [self snapshotImage];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.frame];
    iv.image = image;
    self.superDisplayCell.hidden = YES;
    self.hidden = YES;
       [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor colorWithRGB:0xffffff alpha:1];
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    [window addSubview:bgView];
    UIView *mastView = [[UIView alloc] initWithFrame:self.frame];
    [mastView addSubview:iv];
    mastView.layer.masksToBounds = YES;
    [bgView addSubview:mastView];
    CGFloat kwidthSS =  (kFullScreenWidth-30*kWidthMultiple6)/(kFullScreenWidth);
    
    CGFloat xwidth = iv.width*kwidthSS;
    CGFloat height = iv.height*kwidthSS;
    CGFloat imgDispHeight =(self.image.size.height*(kFullScreenSize.width-30*kWidthMultiple6))/self.image.size.width;
    [UIView animateWithDuration:0.35 animations:^{
        iv.width = xwidth;
        iv.height = height;
        mastView.frame = self.lastDisplayRect;
        bgView.backgroundColor = [UIColor colorWithRGB:0xffffff alpha:0];
        mastView.layer.cornerRadius = 5;
        iv.top = (-imgDispHeight+self.lastDisplayRect.size.height)/2;
    }
                     completion:^(BOOL finished) {
                         [mastView removeFromSuperview];
                         [bgView removeFromSuperview];
                         self.superDisplayCell.hidden = NO;
                         NSArray *array = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.99, 0.99, 1.0)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
                         [[self class] shakeToShow:self.superDisplayCell array:array time:0.2];
                      
                         [self removeFromSuperview];
                     }];
}


///放大缩小动画
+ (void)shakeToShow:(UIView*)aView array:(NSArray*)array time:(CGFloat)time{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = time;
    NSMutableArray *values = [NSMutableArray arrayWithArray:array];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}


- (void)dealloc
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

+ (void)joinAnimadetailObj:(HLHealthAdviceDetailModel*)detailObj cell:(HLHealthAdviceTableCell*)cell
{
    if (cell) {
        NSString *imageURL = detailObj.background;
        if ([detailObj.tutorialLink isKindOfClass:[NSString class]]==NO || detailObj.tutorialLink.length==0) {
            return;
        }
        NSData *imageData = nil;
        BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:imageURL]];
        if (isExit) {
            NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imageURL]];
            if (cacheImageKey.length) {
                NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
                if (cacheImagePath.length) {
                    imageData = [NSData dataWithContentsOfFile:cacheImagePath];
                }
            }
        }
        if (!imageData) {
            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        }
        if (imageData==nil) {
            return;
        }
        UIImage *image = [UIImage imageWithData:imageData];
        if (image==nil) {
            return;
        }
        UIImageView *view = cell.cellBgImgView;
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        if (window==nil) {
            return;
        }
        CGFloat kwidthSS =  (kFullScreenWidth-30*kWidthMultiple6)/kFullScreenWidth;
        CGRect rect=[view convertRect: view.bounds toView:window];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:rect];
        iv.image = image;
        HLHealthAdviceDescWebView *descWebView = [[HLHealthAdviceDescWebView alloc] initWithFrame:window.frame];
        [descWebView  initWithUrlStr:detailObj.tutorialLink image:image];
        descWebView.detailModel = detailObj;
        descWebView.lastDisplayRect = rect;
        [descWebView layoutUI];
        CGFloat imgDispHeight =(image.size.height*(kFullScreenSize.width-30*kWidthMultiple6))/image.size.width;
        UIView *bgView = [[UIView alloc] initWithFrame:window.frame];
        bgView.backgroundColor = [UIColor colorWithRGB:0xffffff alpha:0];
        [window addSubview:bgView];
        UIView *mastView = [[UIView alloc] initWithFrame:rect];
        [bgView addSubview:mastView];
        [mastView addSubview:descWebView];
        mastView.layer.masksToBounds = YES;
        mastView.layer.cornerRadius = 5;
        UIImage *iiiiv = [descWebView snapshotImage];
        descWebView.alpha = 0;
        UIImageView *ivv = [[UIImageView alloc] initWithFrame:window.frame];
        ivv.width = kFullScreenWidth-kwidthSS*30;
        ivv.height = kFullScreenSize.height*kwidthSS;
        ivv.image = iiiiv;
        ivv.top = (-imgDispHeight+view.height)/2;
        [mastView addSubview:ivv];
        view.hidden = YES;
        [UIView animateWithDuration:0.35 animations:^{
            ivv.left=-kFullScreenSize.width*0.004;
            ivv.width = kFullScreenSize.width*1.008;
            ivv.height = kFullScreenSize.height*1.008;
            ivv.top=-10;
            descWebView.top =0;
            mastView.frame = window.frame;
            mastView.layer.cornerRadius = 0;
            bgView.backgroundColor = [UIColor colorWithRGB:0xffffff alpha:0.5];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                ivv.left=0;
                ivv.width = kFullScreenSize.width;
                ivv.height = kFullScreenSize.height;
                ivv.top=0;
                bgView.backgroundColor = [UIColor colorWithRGB:0xffffff alpha:1];
                
            } completion:^(BOOL finished) {
                [window addSubview:descWebView];
                [bgView removeFromSuperview];
                [ivv removeFromSuperview];
                
                descWebView.alpha = 1;
                descWebView.superDisplayCell = view;
                view.hidden = NO;//上一个页面的
                [descWebView requestWebview];
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }];
        }];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
        if (translation.y>= 0) {
            return YES;
        }
    return NO;
}

- (void)bg:(UIPanGestureRecognizer*)panGesture
{
    static CGFloat ss=0;
    CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
           ss =self.scrollview.contentOffset.y;
            break;
        case UIGestureRecognizerStateChanged:{
            if (self.scrollview.contentOffset.y==0&&ss-transitionY<-2) {
                  [self buttonClick];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            break;
        }
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0) {
        [self layoutPan];
    }
    else
    {
       // self.scrollview.userInteractionEnabled = YES;
        [self.scrollview removeGestureRecognizer:self.pan];
       
    }
}


//关键的手势过渡的过程
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    //手势百分比
    CGFloat persent = 0;
    CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
    persent = transitionY / panGesture.view.frame.size.height;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
             self.draggingOriginPoint = self.origin;
            [self buttonClick];
            break;
        case UIGestureRecognizerStateChanged:{
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if (self.top>120) {
                [UIView animateWithDuration:0.8 animations:^{
                      self.top = kFullScreenSize.height;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
              
            //消失
            }
            else
            {
                [UIView animateWithDuration:0.4 animations:^{
                    self.top=0;
                }];
            }
            //self.top = 0;
            break;
        }
        default:
            break;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
     [self layoutWebView:webView];
}

- (void)layoutWebView:(UIWebView *)webView
{
    if (self.scrollview==nil) {
        self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth, kFullScreenSize.height)];
        self.scrollview.bounces = NO;
        self.scrollview.delegate = self;
        [self.scrollview.panGestureRecognizer addTarget:self action:@selector(bg:)];
        [self addSubview:self.scrollview];
        if (@available(iOS 11.0, *)) {
            self.scrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
           // self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    if (clientheight_str&&[[self class] isPureFloatOrIntString:clientheight_str]) {
        CGFloat value = [clientheight_str floatValue];
        if (value>20) {
            [self.webView setHeight:value];
        }
        else
        {
            [self.webView setHeight:webView.scrollView.contentSize.height];
        }
    }
    else
    {
        [self.webView setHeight:webView.scrollView.contentSize.height];
    }
    
    if (self.webView.height<webView.scrollView.contentSize.height) {
        self.webView.height =  webView.scrollView.contentSize.height;
    }
   // self.scrollview.delaysContentTouches = YES;
    [self.scrollview addSubview:self.iv];
    [self.scrollview addSubview:self.webView];
    [self.scrollview setContentSize:CGSizeMake(0, self.webView.height+self.iv.bottom)];
    
    if (self.scrollview.height>self.scrollview.contentSize.height) {
        self.scrollview.height = self.scrollview.contentSize.height;
    }
    [self addSubview:self.closetBtn];
    
    [self layoutPan];
}

- (void)layoutPan
{
    if (self.pan==nil)
    {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        pan.delegate = self;
        self.pan=pan;
    }
      [self.scrollview addGestureRecognizer:self.pan];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self layoutWebView:webView];
    
}

//判断字符串是否是整型
+ (BOOL)isPureIntString:(NSString*)string{
    if (string&&[string isKindOfClass:[NSString class]]) {
        NSScanner* scan = [NSScanner scannerWithString:string];
        int val;
        return[scan scanInt:&val] && [scan isAtEnd];
    } else {
        return NO;
    }
}
//判断是否为浮点形：
+ (BOOL)isPureFloatString:(NSString*)string{
    if (string&&[string isKindOfClass:[NSString class]]) {
        NSScanner* scan = [NSScanner scannerWithString:string];
        float val;
        return[scan scanFloat:&val] && [scan isAtEnd];
    } else {
        return NO;
    }
}

+ (BOOL)isPureFloatOrIntString:(NSString*)string {
    return [[self class] isPureIntString:string]||[[self class] isPureFloatString:string];
}

- (void)initWithUrlStr:(NSString*)utrlStr image:(UIImage*)image;
{
    if (self) {
        self.image = image;
        self.urlStr = utrlStr;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth, self.image.size.height*kFullScreenWidth/self.image.size.width)];
        iv.image = self.image;
        self.iv = iv;
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, iv.bottom, kFullScreenWidth, kFullScreenSize.height-iv.bottom-(kDevice_Is_iPhoneX?34:0))];
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        webView.scalesPageToFit = YES;
        webView.delegate = self;
        webView.scrollView.bounces = NO;
        self.webView = webView;
        
    }
   // return self;
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view= [super hitTest:point withEvent:event];
    return view;
}
@end

