//
//  ARDemoViewController.m
//  ARDemo
//
//  Created by Chris Greening on 10/10/2010.
//  CMG Research
//

#import "ARDemoViewController.h"
#import "ImageUtils.h"
#import "ARView.h"
#import "DrumsView.h"
#import <math.h>

@interface ARDemoViewController()

-(void) startCameraCapture;
-(void) stopCameraCapture;

@end

bool isPaused = false;
@implementation ARDemoViewController

@synthesize arView;
@synthesize previewView;




/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	drums_view = [[DrumsView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	songButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	songButton.frame = CGRectMake(0.0, 0.0, 768, 1024);
	[songButton addTarget:self action:@selector(enterSong) forControlEvents:UIControlEventTouchUpInside];
	songSelectView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple_songselect.png"]];
	
	playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	[playButton setBackgroundImage:[UIImage imageNamed:@"play_d.png"] forState:UIControlStateSelected];
	[playButton addTarget:self action:@selector(playPressed) forControlEvents:UIControlEventTouchUpInside];
	playButton.frame = CGRectMake(768- 70, 482, 60, 60);
	playButton.hidden = YES;
	
	
	pauseButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[pauseButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
	[pauseButton setBackgroundImage:[UIImage imageNamed:@"pause_d.png"] forState:UIControlStateSelected];
	[pauseButton addTarget:self action:@selector(pausePressed) forControlEvents:UIControlEventTouchUpInside];
	pauseButton.frame = CGRectMake(768- 70, 482, 60, 60);
	pauseButton.hidden = NO;
	
	
	resetButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[resetButton setBackgroundImage:[UIImage imageNamed:@"restart.png"] forState:UIControlStateNormal];
	[resetButton setBackgroundImage:[UIImage imageNamed:@"restart_d.png"] forState:UIControlStateSelected];
	[resetButton addTarget:self action:@selector(resetPressed) forControlEvents:UIControlEventTouchUpInside];
	resetButton.frame = CGRectMake(768- 70, 482 + 80, 60, 60);
	resetButton.hidden =NO;
	
	backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[backButton setBackgroundImage:[UIImage imageNamed:@"back_d.png"] forState:UIControlStateSelected];
	[backButton addTarget:self action:@selector(resetPressed) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame = CGRectMake(768- 70, 482 - 80, 60, 60);
	backButton.hidden =NO;
	
	
	
	[self.view addSubview:drums_view];
	[self.view addSubview:playButton];
	[self.view addSubview:pauseButton];
	[self.view addSubview:resetButton];
	[self.view addSubview:backButton];
	
	[self.view addSubview:songSelectView];
	[self.view addSubview:songButton];


	CFBundleRef mainBundle = CFBundleGetMainBundle();
//CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, CFSTR("filename"), CFSTR("aiff"), NULL);
//SystemSoundID soundId;
//AudioServicesCreateSystemSoundID(soundFileURLRef, &soundId);
//AudioServicesPlaySystemSound(soundId);

	CFURLRef url;
	url = CFBundleCopyResourceURL(mainBundle, CFSTR("drum0_sound"), CFSTR("wav"), NULL);
	AudioServicesCreateSystemSoundID(url, &drum0_sound);

	url = CFBundleCopyResourceURL(mainBundle, CFSTR("drum1_sound"), CFSTR("wav"), NULL);
	AudioServicesCreateSystemSoundID(url, &drum1_sound);

	url = CFBundleCopyResourceURL(mainBundle, CFSTR("drum2_sound"), CFSTR("wav"), NULL);
	AudioServicesCreateSystemSoundID(url, &drum2_sound);

	url = CFBundleCopyResourceURL(mainBundle, CFSTR("drum3_sound"), CFSTR("wav"), NULL);
	AudioServicesCreateSystemSoundID(url, &drum3_sound);

	url = CFBundleCopyResourceURL(mainBundle, CFSTR("cymbal0_sound"), CFSTR("wav"), NULL);
	AudioServicesCreateSystemSoundID(url, &drum0_sound);

	url = CFBundleCopyResourceURL(mainBundle, CFSTR("drum0_sound"), CFSTR("wav"), NULL);
	AudioServicesCreateSystemSoundID(url, &drum0_sound);
	
	[self startCameraCapture];
}

-(void) enterSong
{
	songButton.hidden = YES;
	songSelectView.hidden = YES;
}

-(void)pausePressed
{
	isPaused = !isPaused;
	playButton.hidden = NO;
	pauseButton.hidden = YES;
}

-(void)playPressed
{
	isPaused = !isPaused;
	playButton.hidden = YES;
	pauseButton.hidden = NO;
}

-(void)resetPressed
{
	
}
-(void)backPressed
{
	songButton.hidden = NO;
	songSelectView.hidden = NO;
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Camera Capture Control

-(AVCaptureDevice *)frontFacingCameraIfAvailable
{
	NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	AVCaptureDevice *captureDevice = nil;
	for (AVCaptureDevice *device in videoDevices)
	{
		if (device.position == AVCaptureDevicePositionFront)
		{
			captureDevice = device;
			break;
		}
	}
	if ( ! captureDevice)
	{
		captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	}
	return captureDevice;
}

-(void) startCameraCapture {
	// start capturing frames
	// Create the AVCapture Session
	session = [[AVCaptureSession alloc] init];
	
	// create a preview layer to show the output from the camera
	AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
	previewLayer.frame = previewView.frame;
	[previewView.layer addSublayer:previewLayer];
	
	// Get the default camera device
//	AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDevice* camera = [self frontFacingCameraIfAvailable];
//	NSLog(@"%@", [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]);
	
	// Create a AVCaptureInput with the camera device
	NSError *error=nil;
	AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
	if (cameraInput == nil) {
		NSLog(@"Error to create camera capture:%@",error);
	}
	
	// Set the output
	AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
	
	// create a queue to run the capture on
	dispatch_queue_t captureQueue=dispatch_queue_create("catpureQueue", NULL);
	
	// setup our delegate
	[videoOutput setSampleBufferDelegate:self queue:captureQueue];

	// configure the pixel format
	videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey,
									 nil];

	// and the size of the frames we want
	[session setSessionPreset:AVCaptureSessionPresetMedium];

	// Add the input and output
	[session addInput:cameraInput];
	[session addOutput:videoOutput];
	
	// Start the session
	[session startRunning];		
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	// only run if we're not already processing an image
//	if(imageToProcess==NULL) {
//		// this is the image buffer
//		CVImageBufferRef cvimgRef = CMSampleBufferGetImageBuffer(sampleBuffer);
//		// Lock the image buffer
//		CVPixelBufferLockBaseAddress(cvimgRef,0);
//		// access the data
//		int width=CVPixelBufferGetWidth(cvimgRef);
//		int height=CVPixelBufferGetHeight(cvimgRef);
//		// get the raw image bytes
//		uint8_t *buf=(uint8_t *) CVPixelBufferGetBaseAddress(cvimgRef);
//		size_t bprow=CVPixelBufferGetBytesPerRow(cvimgRef);
//		// turn it into something useful
//		imageToProcess=createImage(buf, bprow, width, height);
//		// trigger the image processing on the main thread
//		[self performSelectorOnMainThread:@selector(processImage) withObject:nil waitUntilDone:NO];
//	}

	if(IMAGE_to_process == NULL)
	{
		CVImageBufferRef cvimgRef = CMSampleBufferGetImageBuffer(sampleBuffer);
		CVPixelBufferLockBaseAddress(cvimgRef,0);
		int width=CVPixelBufferGetWidth(cvimgRef);
		int height=CVPixelBufferGetHeight(cvimgRef);
		uint8_t *buf=(uint8_t *) CVPixelBufferGetBaseAddress(cvimgRef);
		size_t bprow=CVPixelBufferGetBytesPerRow(cvimgRef);
		IMAGE_to_process=create_image(buf, bprow, width, height);
		[self performSelectorOnMainThread:@selector(process_image) withObject:nil waitUntilDone:NO];
	}
}


-(void) stopCameraCapture {
	[session stopRunning];
	[session release];
	session=nil;
}
#pragma mark -
#pragma mark Image Processing Algos

-(bool)stupid_pixel_detection
{
	CGMutablePathRef pathRef=CGPathCreateMutable();
	for(int y = 0; y < IMAGE_to_process->height; y++)		for(int x = 0; x < IMAGE_to_process->width; x++)
	{
		int r = IMAGE_to_process->pixels[y][4 * x];
		int g = IMAGE_to_process->pixels[y][4 * x + 1];
		int b = IMAGE_to_process->pixels[y][4 * x + 2];
		double euclidean_dist = sqrt(r * r + (g - 255) * (g - 255) + b * b);
		const double euclidean_dist_threshold = 150.0;
		if(euclidean_dist < euclidean_dist_threshold)
		{
//			NSLog(@"pixel at x:%d y:%d is r:%d g:%d b:%d euc:%f", x, y, r, g, b, euclidean_dist);
			CGPathAddRect(pathRef, NULL, CGRectMake(2 + IMAGE_to_process->width - x, y - 2, 5, 5));
		}
	}
	arView.pathToDraw = pathRef;
}

-(bool)pixelDetection:(int)quadrant
{
	int quad_x[6];
	int quad_y[6];
	quad_x[0] = 0;
	quad_y[0] = 0;
	quad_x[1] = 0;
	quad_y[1] = 120;
	quad_x[2] = 0;
	quad_y[2] = 240;
	quad_x[3] = 0;
	quad_y[3] = 360;
	quad_x[4] = 0;
	quad_y[4] = 180;
	quad_x[5] = 360;
	quad_y[5] = 180;
	int pixel_value;
	double euclidean_dist;
	double euclidean_dist_threshold = 150.0;
	
	for(int y = quad_y[quadrant]; y < (quad_y[quadrant] + 140); y = y+2)
	{
		for(int x = quad_x[quadrant]; x < (quad_x[quadrant] + 120); x = x+2)
		{
			int r = IMAGE_to_process->pixels[x][4 * y];
			int g = IMAGE_to_process->pixels[x][4 * y + 1];
			int b = IMAGE_to_process->pixels[x][4 * y + 2];
			
			euclidean_dist = sqrt(r * r + (g - 255) * (g - 255) + b * b);
			if(euclidean_dist < euclidean_dist_threshold)
			{
				NSLog(@"pixel at x:%d y:%d is r:%d g:%d b:%d euc:%f",x, y, r,g,b,euclidean_dist);
				return true;
			}
		}
	}
	return false;
}

// functions involving pixel detection

#pragma mark -
#pragma mark Image processing

-(void)process_image
{
	if(IMAGE_to_process)
	{
		[self stupid_pixel_detection];
		kill_IMAGE_with_fire(IMAGE_to_process);
		IMAGE_to_process = NULL;
	}
	return;
//	if(IMAGE_to_process)
//	{
//		//do processing here!
//		for(int i = 0; i < 6; i++)	
//		{
//			if([self pixelDetection:i])
//			{
//				// Color found in quadrant i, play ith sound
//				NSLog(@"found something in quadrant %d", i);
//				switch(i)
//				{
//					case 0:
//					{
//						AudioServicesPlaySystemSound(drum0_sound);
//						break;
//					}
//					case 1:
//					{
//						AudioServicesPlaySystemSound(drum1_sound);
//						break;
//					}
//					case 2:
//					{
//						AudioServicesPlaySystemSound(drum2_sound);
//						break;
//					}
//					case 3:
//					{
//						AudioServicesPlaySystemSound(drum3_sound);
//						break;
//					}
//					case 4:
//					{
//						AudioServicesPlaySystemSound(cymbal0_sound);
//						break;
//					}
//					case 5:
//					{
//						AudioServicesPlaySystemSound(cymbal1_sound);
//						break;
//					}
//				}
//			}
//		}
//		
//		
//		kill_IMAGE_with_fire(IMAGE_to_process);
//		IMAGE_to_process = NULL;
//	}
}

-(void) processImage {
	if(imageToProcess) {
		// move and scale the overlay view so it is on top of the camera image 
		// (the camera image will be aspect scaled to fit in the preview view)
		float scale=MIN(previewView.frame.size.width/imageToProcess->width, 
						previewView.frame.size.height/imageToProcess->height);
		arView.frame=CGRectMake((previewView.frame.size.width-imageToProcess->width*scale)/2,
									 (previewView.frame.size.height-imageToProcess->height*scale)/2,
									 imageToProcess->width, 
									 imageToProcess->height);
		arView.transform=CGAffineTransformMakeScale(scale, scale);
		
		
		// detect vertical lines
		CGMutablePathRef pathRef=CGPathCreateMutable();
		int lastX=-1000, lastY=-1000;
		for(int y=0; y<imageToProcess->height-1; y++) {
			for(int x=0; x<imageToProcess->width-1; x++) {
				int edge=(abs(imageToProcess->pixels[y][x]-imageToProcess->pixels[y][x+1])+
						  abs(imageToProcess->pixels[y][x]-imageToProcess->pixels[y+1][x])+
						  abs(imageToProcess->pixels[y][x]-imageToProcess->pixels[y+1][x+1]))/3;
				if(edge>10) {
					int dist=(x-lastX)*(x-lastX)+(y-lastY)*(y-lastY);
					if(dist>50) {
						CGPathMoveToPoint(pathRef, NULL, x, y);
						lastX=x;
						lastY=y;
					} else if(dist>10) {
						CGPathAddLineToPoint(pathRef, NULL, x, y);
						lastX=x;
						lastY=y;
					}
				}
			}
		}	
		
		// draw the path we've created in our ARView
		arView.pathToDraw=pathRef;
		
		// done with the image
		destroyImage(imageToProcess);
		imageToProcess=NULL;
	}
}

#pragma mark -

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[self stopCameraCapture];
	self.previewView=nil;
}


- (void)dealloc {
	[self stopCameraCapture];
	self.previewView = nil;

	self.arView = nil;

    [super dealloc];
}

@end
