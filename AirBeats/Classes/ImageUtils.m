/*
 *  ImageUtils.c
 *  AugmentedRealitySample
 *
 *  Created by Chris Greening on 01/01/2010.
 *
 */

#include "ImageUtils.h"

Image *createImage(uint8_t *bytes, size_t bprow, int srcWidth, int srcHeight) {
	// create the image
	Image *result=(Image *) malloc(sizeof(Image));
	result->width=srcHeight;
	result->height=srcWidth;
	result->rawImage=(uint8_t *) malloc(result->width*result->height);
	// create a 2D aray - this makes using the data a lot easier
	result->pixels=(uint8_t **) malloc(sizeof(uint8_t *)*result->height);
	for(int y=0; y<result->height; y++) {
		result->pixels[y]=result->rawImage+y*result->width;
	}
	// process the source BGRA data into 1 bytes greyscale data
	for(int y=0; y<srcHeight; y++) {
		uint8_t *srcRowPtr=bytes+(srcHeight-y-1)*bprow;
		for(int x=0;x<srcWidth;x++) {
			uint8_t blue=*srcRowPtr;	// blue value
			srcRowPtr++;
			uint8_t green=*srcRowPtr;	// green value
			srcRowPtr++;
			uint8_t red=*srcRowPtr;	// red value
			srcRowPtr+=2;			// skip past the alpha value
			// convert to greyscale
			result->pixels[x][y]=MIN(255, 0.3*red+0.59*green+0.11*blue);
		}
	}
	return result;
}

CGImageRef toCGImage(Image *srcImage) {
	// generate space for the result
	uint8_t *rgbData=(uint8_t *) calloc(srcImage->width*srcImage->height*sizeof(uint32_t),1);
	// process the greyscale image back to rgb
	for(int i=0; i<srcImage->height*srcImage->width; i++) {			
		// no alpha
		rgbData[i*4]=0;
		int val=srcImage->rawImage[i];
		// rgb values
		rgbData[i*4+1]=val;
		rgbData[i*4+2]=val;
		rgbData[i*4+3]=val;
	}
	// create the CGImage from this data
	CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
	CGContextRef context=CGBitmapContextCreate(rgbData, 
											   srcImage->width, 
											   srcImage->height, 
											   8, 
											   srcImage->width*sizeof(uint32_t), 
											   colorSpace, 
											   kCGBitmapByteOrder32Little|kCGImageAlphaNoneSkipLast);
	// cleanup
	CGImageRef image=CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	free(rgbData);
	return image;
}

void destroyImage(Image *image) {
	free(image->rawImage);
	free(image->pixels);
	free(image);
}

IMAGE* create_image(uint8_t* bytes, size_t bprow, int src_width, int src_height)
{
//	// create the image
//	Image *result=(Image *) malloc(sizeof(Image));
//	result->width=srcHeight;
//	result->height=srcWidth;
//	result->rawImage=(uint8_t *) malloc(result->width*result->height);
//	// create a 2D aray - this makes using the data a lot easier
//	result->pixels=(uint8_t **) malloc(sizeof(uint8_t *)*result->height);
//	for(int y=0; y<result->height; y++) {
//		result->pixels[y]=result->rawImage+y*result->width;
//	}
//	// process the source BGRA data into 1 bytes greyscale data
//	for(int y=0; y<srcHeight; y++) {
//		uint8_t *srcRowPtr=bytes+(srcHeight-y-1)*bprow;
//		for(int x=0;x<srcWidth;x++) {
//			uint8_t blue=*srcRowPtr;	// blue value
//			srcRowPtr++;
//			uint8_t green=*srcRowPtr;	// green value
//			srcRowPtr++;
//			uint8_t red=*srcRowPtr;	// red value
//			srcRowPtr+=2;			// skip past the alpha value
//			// convert to greyscale
//			result->pixels[x][y]=MIN(255, 0.3*red+0.59*green+0.11*blue);
//		}
//	}
//	return result;
//	
	IMAGE* result = (IMAGE*)malloc(sizeof(IMAGE));
	result->width = src_height;
	result->height = src_width;
	result->raw_image = (uint8_t*)malloc(sizeof(uint8_t) * 4 * result->width * result->height);
	result->pixels = (uint8_t**)malloc(sizeof(uint8_t*) * result->height);
	for(int y = 0; y < result->height; y++)	result->pixels[y] = result->raw_image + 4 * y * result->width;
	for(int y = 0; y < src_height; y++)
	{
		uint8_t* src_row_ptr = bytes + (src_height - y - 1) * bprow;
		for(int x = 0; x < src_width; x++)
		{
			uint8_t b = *(src_row_ptr++);
			uint8_t g = *(src_row_ptr++);
			uint8_t r = *(src_row_ptr++);
			src_row_ptr++;
			result->pixels[x][y * 4 + 0] = r;
			result->pixels[x][y * 4 + 1] = g;
			result->pixels[x][y * 4 + 2] = b;
			result->pixels[x][y * 4 + 3] = 0;
//			NSLog(@"%d %d: %d %d %d", x, y, (int)r, (int)g, (int)b);
		}
	}
	return result;
	
}
void kill_IMAGE_with_fire(IMAGE* img)
{
	free(img->raw_image);
	free(img->pixels);
	free(img);
}