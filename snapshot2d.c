#include <stdio.h>
#include <stdlib.h>
#include "fdtd-macro.h"

static int temporalStride = -2, frame = 0, startTime,
  startNodeX, endNodeX, spatialStrideX,
  startNodeY, endNodeY, spatialStrideY,
  iObs, choice;

static char timefile[80];

void snapshotInit2d(Grid *g) {
  
  printf("Do you want 2D snapshots? (1=yes, 0=no) ");
  scanf("%d", &choice);

  printf("Duration of simulation is %d steps.\n", MaxTime);
  printf("Enter start time and temporal stride: ");
  scanf(" %d %d", &startTime, &temporalStride);
	printf("Start time = %d, Temporal stride = %d\n", startTime, temporalStride);
  printf("In x direction grid has %d total nodes (ranging from 0 to %d).\n", SizeX, SizeX - 1);
  printf("Enter first node, last node, and spatial stride: ");
  scanf(" %d %d %d", &startNodeX, &endNodeX, &spatialStrideX);
	printf("In the x direction:\nFirst node = %d, Last node = %d, Spatial stride = %d\n", startNodeX, endNodeX, spatialStrideX);
  printf("In y direction grid has %d total nodes (ranging from 0 to %d).\n", SizeY, SizeY - 1);
  printf("Enter first node, last node, and spatial stride: ");
  scanf(" %d %d %d", &startNodeY, &endNodeY, &spatialStrideY);
	printf("In y direction:\nFirst node = %d, Last node = %d, Spatial stride = %d\n", startNodeY, endNodeY, spatialStrideY);
  printf("Enter the output filename: ");
  scanf(" %s", timefile);
	printf("Enter the cell in which you want to observe the field: ");
  scanf(" %d", &iObs);
  return;
}

void snapshot2d(Grid *g) {
  int mm, nn;
  float dim1, dim2, temp, temp1;
  char filename[100];
  FILE *snapposition, *snaptime;
  /* ensure temporal stride set to a reasonable value */
 if (temporalStride < 0) {
    fprintf(stderr,
      "snapshot2d: Temporal stride must be set to positive value.\n");
    exit(-1);
  }
	snaptime = fopen(timefile,"ab");
  /* get snapshot if temporal conditions met */
  if (Time >= startTime && 
      (Time - startTime) % temporalStride == 0) {
		//If requested, create shapshot files
    if (choice == 1){
		sprintf(filename, "sim.%d", frame++);
     	snapposition = fopen(filename, "wb");
		// write dimensions to output file and express dimensions as floats
    	dim1 = (endNodeX - startNodeX) / spatialStrideX + 1;
    	dim2 = (endNodeY - startNodeY) / spatialStrideY + 1;
    	fwrite(&dim1, sizeof(float), 1, snapposition);
    	fwrite(&dim2, sizeof(float), 1, snapposition);
	}

    // write remaining data
	for (mm = startNodeX; mm <= endNodeX; mm += spatialStrideX)
   for (nn = endNodeY; nn >= startNodeY; nn -= spatialStrideY) {
		if (choice == 1) {
			temp = (float)Ez(mm, nn); // store data as a float
			fwrite(&temp, sizeof(float), 1, snapposition); // write the float
		}
		if(mm == iObs){
				temp1 = (float)Ez(mm, nn);
				fwrite(&temp1, sizeof(float), 1, snaptime); 
		}	
      }
	

    if (choice == 1) fclose(snapposition);  // close file

  }

		fclose(snaptime);

  return;
}
