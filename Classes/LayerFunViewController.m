//
//  LayerFunViewController.m
//  LayerFun
//
//  Created by Anonymous Apple Employee for Jim Hillhouse on 6/9/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "LayerFunViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation LayerFunViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	pictureImageView.image				= [UIImage imageNamed:@"Steve"];
}

- (void)dealloc 
{
    [super dealloc];
}



- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
	
	[self animate];
}





#pragma mark -
#pragma mark Animation Methods
- (void)animate
{
	CABasicAnimation *picture			= [CABasicAnimation animationWithKeyPath:@"sublayerTransform"];
	picture.fromValue					= [NSNumber numberWithFloat:0.0];
	picture.toValue						= [NSNumber numberWithFloat:M_PI * 2.0];
	picture.valueFunction				= [CAValueFunction functionWithName:kCAValueFunctionRotateY];
	picture.repeatCount					= HUGE_VAL;
	picture.duration					= 5.0;
	[masterView.layer addAnimation:picture forKey:@"sublayerTransform"];
	
	masterView.layer.zPosition			= 0;
	backgroundView.layer.zPosition		= 5;
	pictureView.layer.zPosition			= 10;	
}

@end
