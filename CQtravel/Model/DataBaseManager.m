//
//  DataBaseManager.m
//  new、CQtravel
//
//  Created by zitayangling on 16/4/24.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDB.h"
#define KdataBaseFile @"CQTraver.db"
#define ksigtTypeTable @"SightType"
#define KsightTable @"Sight"

@interface DataBaseManager()

@property (nonatomic,strong) FMDatabase * db;

@end

@implementation DataBaseManager

+ (DataBaseManager *)sharedManager{
    static DataBaseManager *theManager=nil;
    @synchronized (self){
        
        if (theManager==nil) {
            theManager=[[DataBaseManager alloc]init];
        }
    }
    return theManager;
}

//寻找文件    沙盒文件
-(NSString *)DBfilepath{
//    NSArray *list=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path= [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:KdataBaseFile];
    return path;
}

//创建数据库和表
-(instancetype)init{
    self=[super init];
    if (self) {
        
        //创建数据库
        NSString *path=[self DBfilepath];
        NSLog(@"%@",path);
        self.db=[FMDatabase databaseWithPath:path];
        if (![self.db open]) {
            NSLog(@"打开数据库／创建数据库失败");
            return nil;
        }
        // 创建表
        NSString *sqlStr=[NSString stringWithFormat:@"create table if not exists %@ (sortID integer primary key,sightTypeName text)",ksigtTypeTable];
        if (![self.db executeUpdate:sqlStr])
        {
            NSLog(@"打开／创建 %@失败 创建表语句 : %@",ksigtTypeTable,sqlStr);
            return nil;
        }
        
        sqlStr=[NSString stringWithFormat:@"create table if not exists %@ (sightID integer primary key ,sightName text,sortID integer, excerpt text, imageName text,Description text,position text,imageData blob)",KsightTable];
        if (![self.db executeUpdate:sqlStr])
        {
            NSLog(@"打开／创建 %@失败，创建表语句：%@",KsightTable,sqlStr);
            return nil;
        }
    }
    return self;
}
#pragma mark -----  景点类别接口 ----------

//读取
-(NSMutableArray *)readSigtTypeList{
    NSMutableArray *arry=[NSMutableArray array];
    NSString *sqlStr=[NSString stringWithFormat:@"select * from %@",ksigtTypeTable];
    FMResultSet *resultSet=[self.db executeQuery:sqlStr];
    
    while ([resultSet next]) {
        SightType *type=[[SightType alloc]init];
        type.SortID=@([resultSet intForColumn:@"sortID"]).stringValue;
        type.SightTypeName=[resultSet stringForColumn:@"sightTypeName"];
        [arry addObject:type];
        
        
    }
    return arry;
}
-(BOOL)saveSigtTypeList:(NSMutableArray *)theTypeList{
    if (!theTypeList||theTypeList.count==0) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"delete from %@ ",ksigtTypeTable];
    if (![self.db executeUpdate:sqlStr]) {
        NSLog(@"清空表%@出错%@",ksigtTypeTable,self.db.lastErrorMessage);
    }
    for(SightType *type in theTypeList)
    {
        NSString *sqlStr1=[NSString stringWithFormat:@"insert into %@(sortID,sightTypeName) values (?,?)",ksigtTypeTable];
        if (![self.db executeUpdate:sqlStr1,type.SortID,type.SightTypeName])
        {
            NSLog(@"查询错误，错误代码是: %@",sqlStr1);
            return NO;
        }
    }
    return YES;
}
#pragma mark  ----- 景点接口 -------
-(NSMutableArray *)readSigtBySigtTypeList:(SightType *)theType{
    if (!theType) {
        return nil;
    }
    NSMutableArray *arry=[NSMutableArray array];
    
    NSString *sqlStr=[NSString stringWithFormat:@"select * from %@ where sortID= %@",KsightTable,theType.SortID];
    FMResultSet *result=[self.db executeQuery:sqlStr];
    while ([result next]) {
        Sights *sight=[[Sights alloc]init];
        
        sight.sightID = @([result intForColumn:@"sightID"]).stringValue;
        sight.name = [result stringForColumn:@"sightName"];
//        sight.sortid = @([result intForColumn:@"sortID"]).stringValue;
        sight.excerpt = [result stringForColumn:@"excerpt"];
        sight.imageView = [result stringForColumn:@"imageName"];
        sight.Description = [result stringForColumn:@"Description"];
        sight.Position = [result stringForColumn:@"position"];
        sight.imageData = [result dataForColumn:@"imageData"];
        [arry addObject:sight];
    }
    return arry;
}
-(BOOL)saveSigtList:(NSMutableArray *)theList ofsigtType:(SightType *)theType{
    if(!theList||theList.count==0||!theType){
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"delete from %@ where sortID=%@",KsightTable,theType.SortID];
    if (![self.db executeUpdate:sqlStr]) {
        NSLog(@"清空表%@出错%@",KsightTable,self.db.lastErrorMessage);
    }
    
    sqlStr=[NSString stringWithFormat:@"insert into %@ (sightID,sortID,sightName,excerpt,imageName,Description,position,imageData) values(?,%@,?,?,?,?,?,?)",KsightTable,theType.SortID];
    for (Sights *sight in theList) {
        if (![self.db executeUpdate:sqlStr,sight.sightID,sight.name,sight.excerpt,sight.imageView,sight.Description,sight.Position,sight.imageData]) {
            NSLog(@"插入数据出错，SQL语句是：%@, 插入景点名称为： %@",sqlStr,sight.name);
            return NO;
        }
    }
    return YES;
}

-(BOOL)updateSigtList:(Sights *)theList{
    if (!theList) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"update %@ set excerpt=?,sightName=?,Description=?,imageName=?,position=?,imageData=? where sightID=?",KsightTable];
    if (![self.db executeUpdate:sqlStr,theList.excerpt,theList.name,theList.Description,theList.imageView,theList.Position,theList.imageData,theList.sightID]) {
        NSLog(@"修改数据出错，SQL语句是：%@ , 修改的景点名称为：%@",sqlStr,theList.name);
        return NO;
    }else
    {
        NSLog(@"修改数据成功，SQL语句是：%@ , 修改的景点名称为：%@",sqlStr,theList.name);
    }
    return YES;
}

-(NSMutableArray *)randomSigtList:(NSInteger)numberOfSight{
    NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:numberOfSight];
    
    int totalSight;
    
    NSString *sqlStr=[NSString stringWithFormat:@"select count(*) from %@ ",KsightTable];
    
    
    totalSight=[self.db intForQuery:sqlStr];
    NSLog(@"total count= %d",totalSight);
    
    //数组为空，没有获取到景点，返回空
    if (totalSight==0) {
        return nil;
    }
    //可选
    if (totalSight<numberOfSight) {
        numberOfSight=totalSight;
    }
    
    
    while (returnArray.count <numberOfSight ) {
        
        
        Sights *sigtType=[[Sights alloc]init];
        int selectNumber;
        selectNumber=arc4random()%totalSight;
        NSLog(@"----%d",selectNumber);
        
        sqlStr=[[NSString alloc]initWithFormat:@"select * from %@ limit 1 offset %d",KsightTable,selectNumber];
        FMResultSet *resultser=[self.db executeQuery:sqlStr];
        while ([resultser next]) {
            
            sigtType.sightID=@([resultser intForColumn:@"sightID"]).stringValue;
            sigtType.name=[resultser stringForColumn:@"sightName"];
            sigtType.imageView=[resultser stringForColumn:@"imageName"];
            sigtType.excerpt=[resultser stringForColumn:@"excerpt"];
            //        sigtType.sigtDescription=[resultser stringForColumn:@"sigtDescription"];
            sigtType.Position=[resultser stringForColumn:@"position"];
            sigtType.imageData=[resultser dataForColumn:@"imageData"];
        }
        BOOL found=NO;
        for (Sights *sight in returnArray) {
            if ([sigtType.sightID isEqualToString:sight.sightID]) {
                found=YES;
            }
        }
        if (!found) {
            [returnArray addObject:sigtType];
        }
        
        
        
    }
    
    
    return returnArray;
}



@end
