//
//  AddressPickerView.m
//  简单地址选择器
//
//  Created by huhang on 16/4/1.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "AddressPickerView.h"
#import "AddressModel.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface AddressPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

/** 选择器 */
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic,strong)NSMutableArray *provinceDatas;

@property (nonatomic,assign)NSInteger currentProvinceIndex;
@property (nonatomic,assign)NSInteger currentCityIndex;
@property (nonatomic,assign)NSInteger currentCountyIndex;

@end

@implementation AddressPickerView

+ (instancetype)picerView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.frame = CGRectMake(10, screenHeight - 250, screenWidth - 20, 250);
    self.pickerView.layer.borderWidth = 0.5;
    self.pickerView.frame = self.bounds;
    self.pickerView.layer.borderColor = [UIColor grayColor].CGColor;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    
    self.provinceDatas = [NSMutableArray array];
    
    [self setupPickerData];
}

- (void)setupPickerData{

    NSArray *countys = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"County.plist" ofType:nil]];
    NSMutableArray *countyArr = [NSMutableArray array];
    for (NSDictionary *dict in countys) {
        County *county = [[County alloc]init];
        county.cityIdStr = dict[@"cityid"];
        county.idStr = dict[@"id"];
        county.countyName = dict[@"name"];
        [countyArr addObject:county];
    }
    
    NSArray *citys = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"City.plist" ofType:nil]];
    NSMutableArray *cityArr = [NSMutableArray array];
    for (NSDictionary *dict in citys) {
        City *city = [[City alloc]init];
        city.provinceIdStr = dict[@"provinceid"];
        city.idStr = dict[@"id"];
        city.cityName = dict[@"name"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityIdStr = %@",city.idStr];
        city.countys = [countyArr filteredArrayUsingPredicate:predicate];
        [cityArr addObject:city];
    }
    
    NSArray *provinces = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Province.plist" ofType:nil]];
    for (NSDictionary *dict in provinces) {
        Province *province = [[Province alloc]init];
        province.idStr = dict[@"id"];
        province.provinceName = dict[@"name"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"provinceIdStr = %@",province.idStr];
        province.citys = [cityArr filteredArrayUsingPredicate:predicate];
        [self.provinceDatas addObject:province];
    }
    
    [self.pickerView reloadAllComponents];
}

//返回分区数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

//返回cell个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0){
        return self.provinceDatas.count;
    }else if (component == 1){
        Province *province = self.provinceDatas[self.currentProvinceIndex];
        return province.citys.count;
    }else{
        Province *province = self.provinceDatas[self.currentProvinceIndex];
        City *city = province.citys[self.currentCityIndex];
        return city.countys.count;
    }
}

//返回cell
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *pickerTextLb = (UILabel *)view;
    if (!pickerTextLb) {
        pickerTextLb = [[UILabel alloc]init];
        pickerTextLb.textColor = [UIColor darkGrayColor];
        pickerTextLb.adjustsFontSizeToFitWidth = YES;
        pickerTextLb.textAlignment = NSTextAlignmentCenter;
        pickerTextLb.font = [UIFont systemFontOfSize:16];
    }
    pickerTextLb.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerTextLb;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0){
        Province *province = self.provinceDatas[row];
        return province.provinceName;
    }else if (component == 1){
        Province *province = self.provinceDatas[self.currentProvinceIndex];
        City *city = province.citys[row];
        return city.cityName;
    }else{
        Province *province = self.provinceDatas[self.currentProvinceIndex];
        City *city = province.citys[self.currentCityIndex];
        County *county = city.countys[row];
        return county.countyName;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component == 0) {
        self.currentProvinceIndex = row;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        self.currentCityIndex = 0;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        self.currentCountyIndex = 0;
    }else if (component == 1){
        self.currentCityIndex = row;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        self.currentCountyIndex = 0;
    }else{
        self.currentCountyIndex = row;
    }
}

- (IBAction)back {
    NSLog(@"选择器收起来");
}

- (IBAction)sureAction:(id)sender {
    Province *province = self.provinceDatas[self.currentProvinceIndex];
    City *city = province.citys[self.currentCityIndex];
    County *county = city.countys[self.currentCountyIndex];
    NSLog(@"--- %@ %@ %@",province.provinceName,city.cityName,county.countyName);
}

@end
