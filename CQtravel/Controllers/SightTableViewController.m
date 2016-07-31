//
//  SightTableViewController.m
//  new、CQtravel
//
//  Created by zitayangling on 16/4/24.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "SightTableViewController.h"
#import "DataBaseManager.h"
#import "RXMLElement.h"
#import "Sights.h"
#import "SightType.h"
@interface SightTableViewController ()

@property (nonatomic,strong) SightType * Items;
@property (strong,nonatomic) NSMutableArray *list;
@property (strong,nonatomic) NSIndexPath *indexPath;

@end

@implementation SightTableViewController
-(NSMutableArray *)list{
    if (!_list) {
        _list=[NSMutableArray array];
    }
    return _list;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.Items.SightTypeName;
    self.tableView.separatorStyle = NO;
    DataBaseManager *manager=[DataBaseManager sharedManager];
    self.list=[manager readSigtBySigtTypeList:self.Items];
    if (!self.list||self.list.count==0)
    {
        [self downloadXML];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)downloadXML{
    
    NSString *address=[NSString stringWithFormat:@"http://1100163.sinaapp.com/open/?sort=%@",self.Items.SortID];
    NSURL *url=[NSURL URLWithString:address];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        [self.list removeAllObjects];
        if (connectionError) {
            NSLog(@"出错了%@",connectionError);
            return ;
        }
        [self pasteXMl:data];
    }];
}
-(void)pasteXMl:(NSData *)data{
    [self.list removeAllObjects];
    RXMLElement *root=[RXMLElement elementFromHTMLData:data];
    [root iterateWithRootXPath:@"//city" usingBlock:^(RXMLElement *sigt) {
        Sights *Type=[[Sights alloc]init];
        Type.sightID = [sigt child:@"id"].text;
        Type.name=[sigt child:@"name"].text;
        Type.imageView=[sigt child:@"headimg"].text;
        Type.excerpt=[sigt child:@"excerpt"].text;
        Type.Position=[sigt child:@"postion"].text;
//        Type.Description=[sigt child:@"description"].text;
        [self.list addObject:Type];
    }];
    
    DataBaseManager *manager=[DataBaseManager sharedManager];
    [manager saveSigtList:self.list ofsigtType:self.Items];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pulldowntorefresh:(UIRefreshControl *)sender {
    
    
    [self downloadXML];
    [sender endRefreshing];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sigtCell" forIndexPath:indexPath];

    // Configure the cell...
    Sights *listItem=self.list[indexPath.row];
    
    UILabel *Name=(UILabel *) [cell viewWithTag:2];
    UITextView *textView=(UITextView *) [cell viewWithTag:3];
    UIImageView *ImageView=(UIImageView *) [cell viewWithTag:4];
    Name.text=listItem.name;
    textView.text=listItem.excerpt;
    textView.editable = NO;
    ImageView.layer.cornerRadius = 50;
    ImageView.layer.masksToBounds = YES;
    
    
    if (listItem.imageData) {
    ImageView.image=[UIImage imageWithData:listItem.imageData];
    }
    else
    {
        NSURL *url=[NSURL URLWithString:listItem.imageView];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
        {
        if (connectionError)
        {   
            NSLog(@"%@",connectionError);
            return ;
        }
        NSHTTPURLResponse *res=(NSHTTPURLResponse *)response;
        if (res.statusCode!=200)
        {
            NSLog(@"服务器有错误哦！！%ld",(long)res.statusCode);
            return ;
        }
        DataBaseManager *manager=[DataBaseManager sharedManager];
        ImageView.image=[UIImage imageWithData:data];
        listItem.imageData=data;
        [manager updateSigtList:listItem];

    }];
    }
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
    if ([segue.identifier isEqualToString:@"sight2web"]) {
        NSIndexPath *indexpath=[self.tableView indexPathForCell:sender];
        Sights *sigtType=self.list[indexpath.row];
        [desVC setValue: sigtType forKey:@"thesight"];
        
    }
    if ([segue.identifier isEqualToString:@"sigtTypeTo"]) {
        [desVC setValue:self.list forKey:@"sigtArray"];
    }
}

@end
