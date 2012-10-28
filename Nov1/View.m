//
//  View.m
//  Nov1
//
//  Created by Scott Danzig on 10/27/12.
//  Copyright (c) 2012 Scott Danzig. All rights reserved.
//

#import "View.h"

@implementation View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 Clapboard info:
 
 Production:
 Director:
 Camera:
 Date:      Scene:    Take:
 */

- (void)drawRect:(CGRect)rect
{
    // Find bounds
    // Set background to light brown
    // Set origin to upper left bound of clapboard (4/5 length, 3/5 height)
    // Create path
    //
    // Create bodySubPath
    // Draw black filled rectangle for body of clipboard
    // Add shadow
	// Draw lines:
    //     Lines should be white with rounded corners, a little past the edge
    //     Set origin to 5 pixels down, 5 left
    //     Text area height = (body height - 10) / 4
    //     Default text area width = (body width - 10)
    //     Date area width = Default text area width / 2
    //     Scene area width = Default text area width / 4
    //     Take area width = Default text area width / 4
    // Draw white text in each text area.
    // Date format should be "Oct 5, 2012"
    // Hardcode values of scene = 12G, take = 4
    //
    // Create stickSubPath
    // Draw black filled rectangle for stick
    // Add shadow
    // Stick will be divided into 11 blocks, with the middle 7 colored
    // Block width = stick width / 11;
    // Create array of color codes.
    // For each color code, draw block from x = block width * (2 + color code index), y = 0,
    // height = stick height, width = block width
    // create function rotateStick that rotates stick, pivoting on the lower left corner
    // create playStickCrack function that plays a sound file of a clapboard noise
    // delayed call of rotateStick, going smoothly up till 15 degrees in one second.
    // add touch handler that calls rotateStick, rotating down 15 degrees and calling playStickCrack
}

@end
