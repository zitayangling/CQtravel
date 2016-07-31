//
//  DataBaseManager.h
//  new、CQtravel
//
//  Created by zitayangling on 16/4/24.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sights.h"
#import "SightType.h"

@interface DataBaseManager : NSObject
+ (DataBaseManager *)sharedManager;
-(NSString *)DBfilepath;
-(instancetype)init;
-(NSMutableArray *)readSigtTypeList;
-(BOOL)saveSigtTypeList:(NSMutableArray *)theTypeList;

-(NSMutableArray *)readSigtBySigtTypeList:(SightType *)theSight;
-(BOOL)saveSigtList:(NSMutableArray *)theList ofsigtType:(SightType *)theSight;
-(BOOL)updateSigtList:(Sights *)theList;
-(NSMutableArray *)randomSigtList:(NSInteger)numberOfSight;
@end
