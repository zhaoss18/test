//
//  ViewController.m
//  HLWebViewAdvice
//
//  Created by zss on 2018/10/22.
//  Copyright © 2018年 HL. All rights reserved.
//

#import "ViewController.h"
#import "HLHealthAdviceTableCell.h"
#import "HLHealthAdviceModel.h"
#import "HLHealthAdviceDescWebView.h"
#import "HLScreenFitTool.h"
#import "hDefine.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"测试弹出动画效果";
    [self initTable];
}


- (void)initTable {
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat height = screenSize.height - self.navigationController.navigationBar.frame.size.height;
    CGFloat cHeight = (kDevice_Is_iPhoneX?44:20);
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height+cHeight, screenSize.width,height-cHeight) style:UITableViewStylePlain];
    tableView.backgroundColor= [UIColor clearColor];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.showsHorizontalScrollIndicator=NO;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:_tableView=tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
}

#pragma mark -  UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return HLSizeW(110);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FLT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const identifier = @"basetablecell";
    HLHealthAdviceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HLHealthAdviceTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    HLHealthAdviceDetailModel *detailObj = [[HLHealthAdviceDetailModel alloc] init];
    detailObj.taskName = @"testtt";
    detailObj.background =@"http://helian.image.alimmdn.com/healthmanage/managefile/2018/04/0b9b208598364daca0c6a24686470486.jpg";
    [cell updataCellAdviceData:detailObj];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HLHealthAdviceDetailModel *detailObj = [[HLHealthAdviceDetailModel alloc] init];
    detailObj.taskName = @"testtt";
    detailObj.background =@"http://helian.image.alimmdn.com/healthmanage/managefile/2018/04/0b9b208598364daca0c6a24686470486.jpg";
    detailObj.tutorialLink = @"https://appimg.helianhealth.com/Activitys/zx-jianya.html";
              HLHealthAdviceTableCell *cell =   [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
         [HLHealthAdviceDescWebView joinAnimadetailObj:detailObj cell:cell];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
