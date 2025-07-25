/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	FILE *fp = fopen(filename,"r");
	if (fp == NULL) {
		printf("Fail to open %s!\n", filename);
		return NULL;
	}
	char format[3]; //要储存终止符
	fscanf(fp, "%s", format);
	if (format[0] != 'P' || format[1] != '3'){
		printf("Wrong PPM format: %s\n",format);
		return NULL;
	}
	int cols, rows, max_v;
	fscanf(fp, "%d %d %d",&cols, &rows, &max_v );
	if (cols <=0 || rows <= 0 || max_v!=255){
		printf("Invalid image!\n");
		return NULL;
	}
	//分配内存
	Image *img = (Image*)(malloc(sizeof(Image)));
	img->image = (Color**)(malloc(cols * rows * sizeof(Color*)));
	if (img == NULL || img->image == NULL){
		printf("Malloc fail!");
		return NULL;
	}

	img->cols = cols;
	img->rows = rows;

	//生成Image
	Color *pixel;
	for (int i = 0; i < img->cols * img-> rows; i++){
		pixel= (Color*)(malloc(sizeof(Color)));
		if (pixel == NULL){
			printf("Malloc fail!");
				return NULL;
		}
		fscanf(fp, "%hhu %hhu %hhu", &(pixel->R), &(pixel->G), &(pixel->B));
		*(img->image + i) = pixel;
	}
	fclose(fp);
	return img;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	Color **img = image->image;
	printf("P3\n%d %d\n255\n", image->cols, image->rows);
	for (int i = 0; i < image->rows; i++)
		for (int j = 0; j < image->cols; j++)
		{
			printf("%3hhu %3hhu %3hhu", (*img)->R, (*img)->G, (*img)->B);
			if (j < image->cols - 1)
				printf("   ");
			else 
				printf("\n");
			img++;
		}
	return;
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	for (int i = 0; i < image->cols * image -> rows; i++){
	free(*(image->image + i));	
	}
	free(image->image);
	free(image);
	return;
}
