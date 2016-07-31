//
//  MapViewController.m
//  new、CQtravel
//
//  Created by zitayangling on 16/4/27.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Sights.h"
#import "SightType.h"
#import "DataBaseManager.h"
#import "RXMLElement.h"

@interface MapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) Sights *theSight;//web2
@property (strong,nonatomic) NSArray *sigtArray;//sight2
@property (strong,nonatomic) NSMutableArray *mapPlace;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@",self.sigtArray);
    
    if (self.sigtArray||self.sigtArray.count!=0)
    {
        [self map];
        
        float latetitudeMin, latetitudeMax,longtitudeMin,longtitudeMax;
        Sights *place=self.sigtArray.firstObject;
        latetitudeMin=place.coordinate.latitude;
        latetitudeMax=latetitudeMin;
        longtitudeMin=place.coordinate.longitude;
        longtitudeMax=longtitudeMin;
        for (Sights *aPlace in self.sigtArray) {
            float late=aPlace.coordinate.latitude;//维度
            float longt=aPlace.coordinate.longitude;//经度
            if (late<latetitudeMin) {
                latetitudeMin=late;
            }
            if (late>latetitudeMax) {
                latetitudeMax=late;
            }
            if (longt<longtitudeMin) {
                longtitudeMin=longt;
            }
            if (longt>longtitudeMax) {
                longtitudeMax=longt;
            }
            
            CLLocationCoordinate2D center=CLLocationCoordinate2DMake(0.5*(latetitudeMax+latetitudeMin), 0.5*(longtitudeMax+longtitudeMin));
            MKCoordinateSpan span=MKCoordinateSpanMake((latetitudeMax-latetitudeMin)+0.5, (longtitudeMax-longtitudeMin)+0.5);
            MKCoordinateRegion region=MKCoordinateRegionMake(center, span);
            self.mapView.region=region;
        }
        [self.mapView addAnnotations:self.sigtArray];
    }
    else
    {
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(self.theSight.coordinate, 500, 200);//区域
        
        self.mapView.delegate=self;
        [self.mapView addAnnotation:self.theSight];
        [self.mapView setRegion:region animated:YES];
        
    }
    
}
-(void)map{
    
    
    self.mapView.delegate=self;
    
//    [self.locationManager stopUpdatingLocation];
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(self.theSight.coordinate, 500, 200);
    [self.mapView setRegion:region animated:YES];
    [self.mapView addAnnotation:self.theSight];
    [self.mapView selectAnnotation:self.theSight animated:YES];
}


//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//  
//}


@end
