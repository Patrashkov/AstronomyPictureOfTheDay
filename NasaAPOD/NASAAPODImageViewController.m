//
//  NASAAPODImageViewController.m
//  NasaAPOD
//
//  Created by Vladislav on 3/27/16.
//  Copyright © 2016 Vladislav Patrashkov. All rights reserved.
//


#import "NASAAPODImageViewController.h"
#import "NASAAPODPicturiesPageViewController.h"


@interface NASAAPODImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameImageLabel;
@property (weak, nonatomic) IBOutlet UITextView *dscriptionTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSURLSession *session;

@end

static NSString *const kStringWithURL = @"https://api.nasa.gov/planetary/apod";
static NSString *const kStringForAPI = @"3pnMZbIrmKRwsxf1OxOxD7F7Xta3easMItbZXf17";

@implementation NASAAPODImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataWithAPI];
}


#pragma mark - Private
- (NSString *)formaterDate:(NSDate *)date {
    NSDateFormatter *formater = [NSDateFormatter new];
    [formater setDateFormat:@"YYYY-MM-dd"];
    return [formater stringFromDate:self.date];
}


#pragma mark - LoadData
- (void)loadDataWithAPI {
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    NSString *urlString = [NSString stringWithFormat:@"%@?api_key=%@&date=%@",kStringWithURL, kStringForAPI, [self formaterDate:self.date]];
    NSURL *url = [NSURL URLWithString:urlString];
    [[self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            self.nameImageLabel.textColor = [UIColor redColor];
            self.nameImageLabel.text = @"W R O N G";
            self.backgroundImageView.image = [UIImage imageNamed:@"default"];
        }
        else {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (dataDict[@"msg"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.nameImageLabel.text = dataDict[@"msg"];
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.nameImageLabel.text = dataDict[@"title"];
                    self.dscriptionTextView.text = dataDict[@"explanation"];
                    self.dateLabel.text = dataDict[@"date"];
                    [self loadImage:dataDict[@"url"]];
                });
            }
        }
    }] resume];
}

- (void)loadImage:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask *imageTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *dataImage = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                self.nameImageLabel.textColor = [UIColor redColor];
                self.nameImageLabel.text = @"W R O N G";
                self.backgroundImageView.image = [UIImage imageNamed:@"default"];
            }
            else {
                self.backgroundImageView.image = dataImage;
                self.activityIndicator.hidden = YES;
                [self.activityIndicator stopAnimating];
            }
        });
    }];
    [imageTask resume];
}

@end
