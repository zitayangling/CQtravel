//
//  Sights.h
//  new、CQtravel
//
//  Created by zitayangling on 16/4/24.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Sights : NSObject<MKAnnotation>
@property (nonatomic,copy) NSString * excerpt;//景点信息
@property (copy,nonatomic) NSString * name;//景点名称
@property (strong,nonatomic) NSString * sightID;//景点id
@property (strong,nonatomic) NSString * sortid;//景点类别ID
@property (copy,nonatomic) NSString * imageView;//景点图片
@property (copy,nonatomic) NSString * Description;//景点详情
@property (copy,nonatomic) NSString * Position;//景点坐标
@property (strong,nonatomic) NSData * imageData;

@property (readonly,nonatomic) CLLocationCoordinate2D coordinate;//坐标
@end
