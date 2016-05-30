//
//  ViewController.m
//  简单地址选择器
//
//  Created by huhang on 16/4/1.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "ViewController.h"
#import "AddressPickerView.h"
@interface ViewController ()

@property (nonatomic,strong)AddressPickerView *pickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerView = [AddressPickerView picerView];
    [self.view addSubview:self.pickerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
