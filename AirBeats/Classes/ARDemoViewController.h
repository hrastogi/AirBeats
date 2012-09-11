//
//  ARDemoViewController.h
//  ARDemo
//
//  Created by Chris Greening on 10/10/2010.
//  CMG Research
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ImageUtils.h"
#import <AudioToolbox/AudioToolbox.h>

@class ARView;
@class DrumsView;

@interface ARDemoViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
	AVCaptureSession *session;
	UIView *previewView;
	ARView *arView;
	Image *imageToProcess;
	IMAGE* IMAGE_to_process;
	DrumsView* drums_view;
	SystemSoundID drum0_sound;
	SystemSoundID drum1_sound;
	SystemSoundID drum2_sound;
	SystemSoundID drum3_sound;
	SystemSoundID cymbal0_sound;
	SystemSoundID cymbal1_sound;
	
	
	UIImageView* songSelectView;
	UIButton* songButton;
	UIButton* pauseButton;
	UIButton* resetButton;
	UIButton* playButton;
	UIButton* backButton;
}

@property (nonatomic, retain) IBOutlet UIView *arView;
@property (nonatomic, retain) IBOutlet UIView *previewView;

@end

