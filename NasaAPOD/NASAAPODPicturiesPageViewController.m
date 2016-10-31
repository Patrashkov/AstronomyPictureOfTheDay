//
//  NASAAPODPicturiesPageViewController.m
//  NasaAPOD
//
//  Created by Vladislav on 3/27/16.
//  Copyright © 2016 Vladislav Patrashkov. All rights reserved.
//

#import "NASAAPODPicturiesPageViewController.h"
#import "NASAAPODImageViewController.h"


@interface NASAAPODPicturiesPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSDate *date;

@end

@implementation NASAAPODPicturiesPageViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self internalInitialization];
    }
    return self;
}


#pragma mark - private
- (void)internalInitialization {
    self.date = [NSDate date];
    self.delegate = self;
    self.dataSource = self;
    
    NASAAPODImageViewController *imageViewController = [self imageViewController];
    imageViewController.date = self.date;
    [self setViewControllers:@[imageViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (NASAAPODImageViewController *)imageViewController {
    UIStoryboard *stryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [stryboard instantiateViewControllerWithIdentifier:@"NSAAPODImageViewController"];
}

- (NSDate *)dateForDerection:(UIPageViewControllerNavigationDirection)direction {
    if (direction == UIPageViewControllerNavigationDirectionForward) {
        self.date = [self.date dateByAddingTimeInterval: 60 * 60 * 24];
    }
    else if (direction == UIPageViewControllerNavigationDirectionReverse) {
        self.date = [self.date dateByAddingTimeInterval: -(60 * 60 * 24)];
    }
    return self.date;
}


#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NASAAPODImageViewController *imageViewController = [self imageViewController];
    imageViewController.date = [self dateForDerection:UIPageViewControllerNavigationDirectionReverse];
    return imageViewController;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NASAAPODImageViewController *imageViewController = [self imageViewController];
    imageViewController.date = [self dateForDerection:UIPageViewControllerNavigationDirectionForward];
    return imageViewController;
}

@end
