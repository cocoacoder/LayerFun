//
//  LayerFunViewController6.m
//  LayerFunFinal
//
//  Created by James Hillhouse on 1/20/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//


#define LAYER1_TIME_DELAY (0.15) 
#define LAYER2_TIME_DELAY (LAYER1_TIME_DELAY * 5)


#import "LayerFunViewController7.h"


@implementation LayerFunViewController7


@synthesize pageLabel;
@synthesize perspectiveSlider;
@synthesize pictureDistanceSlider;
@synthesize rotationAngleSlider;

@synthesize masterView;
@synthesize pictureView;
@synthesize backgroundView;
@synthesize pictureImageView;
@synthesize pictureFrameView;
@synthesize pictureFrameImageView;

@synthesize perspectiveMultiple;



/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.view.backgroundColor					= [UIColor whiteColor];
	
	rootLayer									= [CATransformLayer layer];
	rootLayer.frame								= self.view.bounds;
	
	
	//
	// Create the 3D Transform
	//
	CATransform3D transform3D					= CATransform3DIdentity;
	transform3D.m34								= - 1.0 / 100.0 * self.perspectiveMultiple;
	
	
	//
	// Rotate and Reposition the Camera
	//
	transform3D									= CATransform3DTranslate(transform3D, 0, -40, -210);
	transform3D									= CATransform3DRotate(transform3D, 0.4, -1.0, -1.0, 0);
	rootLayer.sublayerTransform					= transform3D;
	
	
	//
	// Create the Replicator Layer & Set Its Attributes
	//
	replicantLayer1								= [CAReplicatorLayer layer];
	replicantLayer1.frame						= CGRectMake(0.0, 0.0, 20.0, 20.0);
	replicantLayer1.position					= CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 3.0);
	replicantLayer1.instanceDelay				= LAYER1_TIME_DELAY;
	replicantLayer1.preservesDepth				= YES;
	replicantLayer1.zPosition					= 200.0;
	replicantLayer1.anchorPointZ				= - 160.0;
	replicantLayer1.borderColor					= [UIColor lightGrayColor].CGColor;
	
}


- (void)dealloc 
{
	[pageLabel release];
	[perspectiveSlider release];
	[pictureDistanceSlider release];
	[rotationAngleSlider release];
	
    [super dealloc];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
