//
//  SightWebViewController.m
//  new、CQtravel
//
//  Created by zitayangling on 16/4/27.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "SightWebViewController.h"
#import "Sights.h"
#import "RXMLElement.h"
#import "DataBaseManager.h"
@interface SightWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) Sights *thesight;

@end

@implementation SightWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.title = self.thesight.name;
    
    if (!self.thesight.Description) {
        [self downloadXML];
    }else {
        [self.webView loadHTMLString:self.thesight.Description baseURL:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadXML{
    NSString *address=[NSString stringWithFormat:@"http://1100163.sinaapp.com/open/?p=%@",self.thesight.sightID];
    NSURL *url=[NSURL URLWithString:address];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"%@",connectionError);
            return ;
        }
        NSHTTPURLResponse *res=(NSHTTPURLResponse *) response;
        if (res.statusCode!=200) {
            NSLog(@"服务器连接失败，请检查网络:%ld",(long)res.statusCode);
            return ;
        }
        [self pasteXML:data];
    }];
}
-(void)pasteXML:(NSData *)Xmldata{
    RXMLElement *root=[RXMLElement elementFromXMLData:Xmldata];
    [root iterateWithRootXPath:@"//city/description" usingBlock:^(RXMLElement *sigtType) {
        self.thesight.Description=sigtType.text;
        //        [self.WebView loadHTMLString:type.sigtDescription baseURL:nil];
        DataBaseManager *manager=[DataBaseManager sharedManager];
        BOOL success=[manager updateSigtList:self.thesight];
        if (!success) {
            NSLog(@"景点数据库更新失败，景点名称:%@",self.thesight.name);
        }
        [self.webView loadHTMLString:sigtType.text baseURL:nil];
        
    }];}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
 
    // Pass the selected object to the new view controller.
    UIViewController *desVC=segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"toMap"]) {
        [desVC setValue:self.thesight forKey:@"theSight"];
    }
}


@end
