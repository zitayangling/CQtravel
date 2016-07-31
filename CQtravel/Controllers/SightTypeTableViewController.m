//
//  SightTypeTableViewController.m
//  new、CQtravel
//
//  Created by zitayangling on 16/4/24.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "SightTypeTableViewController.h"

#import "DataBaseManager.h"
#import "SightType.h"
#import "Sights.h"
#import "RXMLElement.h"
#import <AVFoundation/AVFoundation.h>//
#define KTitle @"景点类别"

@interface SightTypeTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) AVAudioPlayer * backgroundMusic;
@property (strong,nonatomic) NSMutableArray *Itemlist;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *images;
@property (strong,nonatomic) NSArray *imagaArray;

@end

@implementation SightTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = KTitle;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    DataBaseManager * manager = [DataBaseManager sharedManager];
    self.Itemlist = [manager readSigtTypeList];
    if (!self.Itemlist||self.Itemlist.count==0)
    {
        [self downloadXML];
    }
//    [self RandomSightImages];
    NSURL * musicURL = [[NSBundle mainBundle]URLForResource:@"onemoretime" withExtension:@"mp3"];
    NSError * error;
    self.backgroundMusic = [[AVAudioPlayer alloc]initWithContentsOfURL:musicURL error:&error];
    if(error)
    {
        NSLog(@"错误%@",error);
    }
    [self.backgroundMusic play];

}

-(NSMutableArray *)Itemlist{
    if (!_Itemlist) {
        _Itemlist=[NSMutableArray array];
        
    }
    return _Itemlist;
}
-(void) downloadXML{
    
    //    短网址 http://dwz.cn/130016-4
    //    NSString *address=@"https://kyfw.12306.cn/otn/lcxxcx/query?purpose_codes=ADULT&queryDate=2014-11-29&from_station=CQW&to_station=BJP";
    NSString *address=@"http://1100163.sinaapp.com/open/?sort=all";
    NSURL *url=[NSURL URLWithString:address];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //    异步下载
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self.Itemlist removeAllObjects];
        if(connectionError){
            NSLog(@"出错了%@",connectionError);
            return ;
        }
        [self parseXML:data];
    }];
}
-(void)parseXML:(NSData *)XMLData
{
    [self.Itemlist removeAllObjects];
    RXMLElement *ress=[RXMLElement elementFromXMLData:XMLData];
    RXMLElement *citys=[ress child:@"citys"];
    NSArray *cityArray=[citys children:@"city"];
    for(RXMLElement *item in cityArray){
        SightType *Item=[[SightType alloc]init];
        Item.SortID=[item child:@"id"].text;
        Item.SightTypeName=[item child:@"name"].text;
        [self.Itemlist addObject:Item];
    }
    DataBaseManager *manger=[DataBaseManager sharedManager];
    [manger saveSigtTypeList:self.Itemlist];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.Itemlist.count;
}


//-(void)downLoadImage:(Sights *)sightType{
//    NSURL *url=[NSURL URLWithString:sightType.imageView];
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (connectionError) {
//            NSLog(@"%@",connectionError);
//            return ;
//            
//        }
//        NSHTTPURLResponse *res=(NSHTTPURLResponse *)response;
//        if (res.statusCode!=200) {
//            NSLog(@"服务器有错误哦！！%ld",(long)res.statusCode);
//            return ;
//        }
//        self.images = [UIImage imageWithData:data];
//        sightType.sigtImageData=data;
//        DataBaseManager *manager=[DataBaseManager sharedManager];
//        [manager updateSigtList:sightType];
//        [self RandomSightImages];
//        
//    }];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
//    DataBaseManager * manager = [DataBaseManager sharedManager];
//    if([manager readSigtTypeList])
//    {
//         NSArray *array = [manager readSigtTypeList];
//        SightType * item = array[indexPath.row];
//        cell.textLabel.text = item.SightTypeName;
//    }else
//    {
    SightType *item=self.Itemlist[indexPath.row];
    cell.textLabel.text=item.SightTypeName;
    cell.textLabel.textAlignment = UITextAlignmentCenter;
//    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *desVC=segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Type2Sight"])
    {
        NSIndexPath *indexpath=[self.tableView indexPathForCell:sender];
        SightType *ViewItem=self.Itemlist[indexpath.row];
        [desVC setValue:ViewItem forKey:@"Items"];
        [self.backgroundMusic stop];
    }
}


@end
