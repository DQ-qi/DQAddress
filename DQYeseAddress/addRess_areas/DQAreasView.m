//
//
// 作者:邓琪 QQ:350218638 gitHub:
//
#import "DQAreasView.h"
#import "DQCanCerEnsureView.h"
#import "DQAreasModel.h"
@interface DQAreasView ()<DQCanCerEnsureViewDelegate>
@property (nonatomic, copy) NSDictionary *areasDict;
@property (nonatomic, strong)DQCanCerEnsureView *CancerEnsure;
@property (strong, nonatomic) NSDictionary *selectedDict;
@property (strong,nonatomic) UIPickerView * pickerView;
@property (nonatomic, strong) UITapGestureRecognizer *ges;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *backView;
@end    
@implementation DQAreasView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0,0, nc_ScreenWidth, nc_ScreenHeight);
        self.window = [[[UIApplication sharedApplication] delegate] window];
        [self.window addSubview:self];
        UIView *blackView1 = [UIView new];
        blackView1.backgroundColor = [UIColor lightGrayColor];
        blackView1.alpha = 0.6f;
        blackView1.frame = CGRectMake(0, 0, nc_ScreenWidth, nc_ScreenHeight);
        [self addSubview:blackView1];
        self.ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GestureCloseSelectViewAnimation:)];
        [self.window bringSubviewToFront:self];
        [blackView1 addGestureRecognizer:self.ges];
        self.backView = [UIView new];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.frame = CGRectMake(0, nc_ScreenHeight, nc_ScreenWidth, 260);
        [self addSubview:self.backView];
        [self creadedtionSubview];
        self.hidden = YES;
    }
    return self;
}

- (void)creadedtionSubview{
    //解析地址
    NSString *path = [[NSBundle mainBundle]pathForResource:@"areas.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.areasDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",self.areasDict);
    self.ProvinceArr = [self.areasDict allKeys];
    NSString *ProvinceStr = [self.ProvinceArr objectAtIndex:0];
    self.selectedDict = [self.areasDict objectForKey:ProvinceStr];
    
    [self calculateCityArrAndCounty:0 andRow:0];
    _CancerEnsure = [[DQCanCerEnsureView alloc]init];
    [_CancerEnsure setTitleText:@"省市县"];
    _CancerEnsure.delegate = self;
    UIView *sub = self.backView;
    [sub  addSubview:_CancerEnsure];
    [_CancerEnsure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sub);
        make.left.equalTo(sub);
        make.right.equalTo(sub);
        make.height.mas_equalTo(45);
    }];
    
    self.pickerView = [UIPickerView new];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    [sub addSubview:self.pickerView];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sub.mas_top).offset(45);
        make.left.equalTo(sub);
        make.right.equalTo(sub);
        make.bottom.equalTo(sub);
    }];

}
//及时更新数据
- (void)calculateCityArrAndCounty:(NSInteger )section andRow:(NSInteger )row{
    if (section == 0) {
        if (self.ProvinceArr.count>row) {
            NSString *ProvinceStr = [self.ProvinceArr objectAtIndex:row];
            self.selectedDict = [self.areasDict objectForKey:ProvinceStr];
            self.cityArr = [self.selectedDict allKeys];
            NSString *countyStr = [self.cityArr firstObject];
            self.countyArr = [self.selectedDict objectForKey:countyStr];
        }
        
    }else if(section == 1){
        if (self.cityArr.count>row) {
            NSString *countyStr = self.cityArr[row];
            self.countyArr = [self.selectedDict objectForKey:countyStr];
        }
        
    }else{
        
        
        
    }
    
    
}
#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;//三组
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.ProvinceArr.count;
    } else if (component == 1) {
        return self.cityArr.count;
    } else {
        return self.countyArr.count;
    }
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lable=[[UILabel alloc]init];
    lable.textAlignment=NSTextAlignmentCenter;
    //    lable.font=[UIFont systemFontOfSize:13];
    if (component == 0) {
        lable.text=[self.ProvinceArr objectAtIndex:row];
    } else if (component == 1) {
        lable.text=[self.cityArr objectAtIndex:row];
    } else if(component == 2){
        if (self.countyArr.count>row) {
            lable.text=[self.countyArr objectAtIndex:row];

        }
    }
    return lable;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return nc_ScreenWidth/3;
    } else if (component == 1) {
        return nc_ScreenWidth/3;
    } else {
        return nc_ScreenWidth/3;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 41;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self calculateCityArrAndCounty:component andRow:row];//实时更新数据
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
    if (component == 1) {
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
}

- (void)ClickCancerDelegateFunction{
    
    [self CloseAnimationFunction];
    
}
- (void)ClickEnsureDelegateFunction{
    
    DQAreasModel *model = [DQAreasModel new];
    model.Province = self.ProvinceArr[[self.pickerView selectedRowInComponent:0]];
    model.city = self.cityArr[[self.pickerView selectedRowInComponent:1]];
    model.county = self.countyArr[[self.pickerView selectedRowInComponent:2]];
    [self CloseAnimationFunction];
    if ([self.delegate respondsToSelector:@selector(clickAreasViewEnsureBtnActionAreasDate:)]) {
        [self.delegate clickAreasViewEnsureBtnActionAreasDate:model];
    }
}
- (void)startAnimationFunction{
    UIView *AnView = self.backView;
    self.hidden = NO;
    CGRect rect = AnView.frame;
    rect.origin.y = nc_ScreenHeight-260;
    [self.window bringSubviewToFront:self];
    [UIView animateWithDuration:0.4 animations:^{
        
        AnView.frame = rect;
    }];
    
}
- (void)CloseAnimationFunction{
    
    UIView *AnView = self.backView;
    CGRect rect = AnView.frame;
    rect.origin.y = nc_ScreenHeight;
    [UIView animateWithDuration:0.4f animations:^{
        AnView.frame = rect;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

- (void)GestureCloseSelectViewAnimation:(UIGestureRecognizer *)ges{
    
    [self CloseAnimationFunction];
}

- (void)dealloc{
    
    self.ges = nil;
    
}
@end
