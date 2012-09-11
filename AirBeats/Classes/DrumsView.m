//
//  DrumsView.m
//  ARDemo
//
//  Created by Ryan Hiroaki Tsukamoto on 9/10/11.
//  Copyright 2011 Miso Media Inc. All rights reserved.
//

#import "DrumsView.h"


@implementation DrumsView

-(id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		drum0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drum0.png"]];
		drum0.frame = CGRectMake(0, 0, 140, 120);
		[self addSubview:drum0];
		
		drum1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drum1.png"]];
		drum1.frame = CGRectMake(0, 120, 140, 120);
		[self addSubview:drum1];
		
		drum2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drum2.png"]];
		drum2.frame = CGRectMake(0, 240, 140, 120);
		[self addSubview:drum2];
		
		drum3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drum3.png"]];
		drum3.frame = CGRectMake(0, 360, 140, 120);
		[self addSubview:drum3];
		
		cymbal0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cymbal0.png"]];
		cymbal0.frame = CGRectMake(180, 0, 140, 120);
		[self addSubview:cymbal0];
		
		cymbal1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cymbal1.png"]];
		cymbal1.frame = CGRectMake(180, 360, 140, 120);
		[self addSubview:cymbal1];
	}
	return self;
}

@end
