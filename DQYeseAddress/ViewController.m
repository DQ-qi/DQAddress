//
//  ViewController.m
//  DQYeseAddress
//
//  Created by DQ on 16/11/15.
//  Copyright © 2016年 GuanzhouDQ. All rights reserved.
//

#import "ViewController.h"
#import "DQAreasView.h"
#import "DQAreasModel.h"
@interface ViewController ()<DQAreasViewDelegate>
@property (nonatomic, strong) UIView *DQbackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (nonatomic, strong) DQAreasView *areasView;//所在地


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.areasView = [DQAreasView new];
    self.areasView.delegate = self;
}

- (IBAction)addRessBtnAction:(UIButton *)sender {
    
   [self.areasView startAnimationFunction];
}
//点击选中哪一行 的代理方法
- (void)clickAreasViewEnsureBtnActionAreasDate:(DQAreasModel *)model{
    
    self.addressLab.text = [NSString stringWithFormat:@"%@ %@ %@",model.Province,model.city,model.county];

    
}

@end
