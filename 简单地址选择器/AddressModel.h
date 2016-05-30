//
//  AddressModel.h
//  简单地址选择器
//
//  Created by huhang on 16/4/1.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject

/** 省id */
@property (nonatomic,copy)NSString *idStr;
/** 省名字 */
@property (nonatomic,copy)NSString *provinceName;

/** 市数组 */
@property (nonatomic,strong)NSArray *citys;

@end

@interface City : NSObject

/** 市中的省id */
@property (nonatomic,copy)NSString *provinceIdStr;
/** 市id */
@property (nonatomic,copy)NSString *idStr;
/** 市名字 */
@property (nonatomic,copy)NSString *cityName;

/** 县数组 */
@property (nonatomic,strong)NSArray *countys;

@end

@interface County : NSObject

@property (nonatomic,copy)NSString *cityIdStr;
/** 县id */
@property (nonatomic,copy)NSString *idStr;
/** 县名字 */
@property (nonatomic,copy)NSString *countyName;

@end


