//
//  HLHealthAdviceTableCell.h
//  LianLianApp2
//
//  Created by zss on 2018/3/24.
//  Copyright © 2018年 zss. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLHealthAdviceDetailModel;

@interface HLHealthAdviceTableCell : UITableViewCell

@property (nonatomic, strong) UILabel *goldNumLabel;
@property (nonatomic, strong) UIImageView *goldImgView;
@property (nonatomic, strong) UIImageView *cellBgImgView;
@property (nonatomic, copy) void(^toFinishedTaskBlock)(HLHealthAdviceDetailModel *taskObj);

- (void)updataCellAdviceData:(HLHealthAdviceDetailModel *)adviceObj;


@end
