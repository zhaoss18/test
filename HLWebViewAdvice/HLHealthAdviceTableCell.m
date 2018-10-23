//
//  HLHealthAdviceTableCell.m
//  LianLianApp2
//
//  Created by zss on 2018/3/24.
//  Copyright © 2018年 zss. All rights reserved.
//

#import "HLHealthAdviceTableCell.h"
#import "HLHealthAdviceModel.h"
#import "HLScreenFitTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <YYKit/YYKit.h>
#import "hDefine.h"
@interface HLHealthAdviceTableCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) HLHealthAdviceDetailModel *currentTaskModel;

@end

@implementation HLHealthAdviceTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.cellBgImgView];
        [_cellBgImgView addSubview:self.titleLabel];
        [_cellBgImgView addSubview:self.goldNumLabel];
        [_cellBgImgView addSubview:self.goldImgView];
        [_cellBgImgView addSubview:self.completeButton];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//判断字符是有效的字符串
+ (BOOL)hlValidString:(NSString *)hlString {
    if ([hlString isKindOfClass:[NSString class]] && hlString.length) {
        return YES;
    } else {
        return NO;
    }
}

- (void)updataCellAdviceData:(HLHealthAdviceDetailModel *)adviceObj {
    _currentTaskModel = adviceObj;
    _titleLabel.text = adviceObj.taskName;
   [_cellBgImgView sd_setImageWithURL:[NSURL URLWithString:adviceObj.background] placeholderImage:[UIImage imageNamed:@"l_advice_default_bg"]];
    
}


#pragma mark -- getter and setter --
- (UIImageView *)cellBgImgView {
    if (!_cellBgImgView) {
        _cellBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(HLFitSizeW(15.f), HLSizeW(15), kFullScreenWidth - HLSizeW(30), HLSizeW(95))];
        _cellBgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _cellBgImgView.userInteractionEnabled = YES;
        _cellBgImgView.layer.cornerRadius = 5.f;
        _cellBgImgView.clipsToBounds = YES;
        _cellBgImgView.backgroundColor = [UIColor colorWithRed:48 green:50 blue:55 alpha:1];
    }
    return _cellBgImgView;
}

- (UILabel *)creatCustomLabelWithFont:(CGFloat)textFont textColor:(UIColor *)color frame:(CGRect)frame {
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:frame];
    tmpLabel.textColor = color;
    tmpLabel.font = [UIFont systemFontOfSize:textFont];
    tmpLabel.textAlignment = NSTextAlignmentLeft;
    
    return tmpLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self creatCustomLabelWithFont:HLSizeW(17.f) textColor:[UIColor whiteColor] frame:CGRectMake(HLSizeW(21.f), HLSizeW(22.f - 12), kFullScreenWidth - HLSizeW(30 + 45 + 21), HLSizeW(24.f + 24))];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _titleLabel;
}


#pragma mark -- 动画 --
- (void)finishAnimationJB:(void(^)(void))animated { //加金币动画
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [_goldNumLabel convertRect:_goldNumLabel.bounds toView:window];
    NSString *s1 = [NSString stringWithFormat:@"+%@",_goldNumLabel.text];
    UILabel *labe1 = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, 100, 100)];
    labe1.font = [UIFont systemFontOfSize:14];
    labe1.text = s1;
    labe1.textColor = [UIColor colorWithRGB:0xFFD80E];
    CGFloat maxwidth = [labe1.text widthForFont: [UIFont systemFontOfSize:40]]+10;
    CGFloat maxheight = [labe1.text heightForFont:[UIFont systemFontOfSize:40] width:300];
    labe1.width = maxwidth;
    labe1.height = labe1.font.capHeight;
    labe1.backgroundColor = [UIColor clearColor];
    [window addSubview:labe1];
    labe1.font = [UIFont systemFontOfSize:13];
    CGAffineTransform transform = labe1.transform;
    [UIView animateWithDuration:2 animations:^{
        labe1.left= rect.origin.x+57+100;
        labe1.top = rect.origin.y-100;
        labe1.width= maxwidth;
        labe1.height = maxheight;
        labe1.alpha = 0.0;
        CGAffineTransform transformMove = CGAffineTransformMakeTranslation(-3, -1);
        CGAffineTransform transformscan = CGAffineTransformScale(transform, 3.0, 3.0);
        CGAffineTransform group = CGAffineTransformConcat(transformMove, transformscan);
        labe1.transform = group;
    } completion:^(BOOL finished) {
        if (finished) {
            [labe1 removeFromSuperview];
        }
        
        if (animated) {
            animated();
        }
    }];
}

@end
