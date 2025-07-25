/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//YOUR CODE HERE
	Color *hid_c = (Color*)(malloc(sizeof(Color)));
	int id = row * image->cols + col;
	Color* color = *(image->image + id);
	hid_c->R = hid_c->G = hid_c->B = (color->B % 2) ? 255:0;
	return hid_c;	
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	//YOUR CODE HERE
	Image *dc_image = (Image*)(malloc(sizeof(Image)));
	dc_image->image = (Color**)(malloc(image->cols * image->rows * sizeof(Color*)));
       for (int i = 0; i < image->rows; i++) 
	 for(int j = 0; j < image->cols; j++){
	 	*(dc_image->image + i * image->cols + j) = evaluateOnePixel(image, i ,j);
	 }      
       dc_image->rows = image->rows;
       dc_image->cols = image->cols;
	return dc_image;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	char *filename = argv[1];
	Image *image = NULL;
	Image *new_image = NULL;
	image = readData(filename);
	if (image == NULL)
		exit(-1);
	new_image = steganography(image);
	writeData(new_image);
	freeImage(image);
	freeImage(new_image);
	return 0;
}
