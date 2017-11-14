#include "fdtd-macro.h"
#include "fdtd-alloc1.h"
#include <math.h>
#include <stdlib.h>
#include <stdio.h>

#define N_NERVE 1.4 //perineurium+epineurium refractive index
#define N_ENDO 1.335 //endoneurium refractive index
#define N_MYELIN 1.4 //myelin refractive index
#define N_ELA 1.41 //elastic fibres refractive index
#define EPSR_WATER 1.7689 //dielectric constant of water
#define X_NERVE 6000 //nerve starting point
#define X_FIBRES 10000 //nerve fibres starting point
#define SIZE 350 //number of nerve fibres (rows in filegrid.txt)

void gridInit(Grid *g) {
  double imp0=377.0, epsr_nerve, epsr_fibres, epsr_endo, epsr_myelin, epsr_ela, n_fibres;
	float temp;
  int mm, nn, i=0, j=0, r[SIZE], r1, xLocation, yLocation, cx[SIZE], cy[SIZE], temp2;
	FILE *read, *out;
	char worg[1], activity[1], dielectric[20];

  Type    = tmZGrid;
  SizeX   = 12000; // size of domain in x
  SizeY   = 2000;	//size of domain in y
  MaxTime = 60000; // duration of simulation
  Cdtds   = 1.0/sqrt(2.0); // Courant number

	//Allocate memory
  ALLOC_2D(g->hx,  SizeX,  SizeY-1, double);
  ALLOC_2D(g->chxh,SizeX,  SizeY-1, double);
  ALLOC_2D(g->chxe,SizeX,  SizeY-1, double);
  ALLOC_2D(g->hy,  SizeX-1,SizeY, double);
  ALLOC_2D(g->chyh,SizeX-1,SizeY, double);
  ALLOC_2D(g->chye,SizeX-1,SizeY, double);
  ALLOC_2D(g->ez,  SizeX,  SizeY, double);
  ALLOC_2D(g->ceze,SizeX,  SizeY, double);
  ALLOC_2D(g->cezh,SizeX,  SizeY, double);

	printf("Sample (s) or reference (r) arm? ");
  scanf(" %s", worg);
	if(strcmp(worg, "s") == 0){
		printf("You have chosen to simulate the sample arm.\n");
		sprintf(dielectric,"dielectric_%1s",worg);
		printf("Is the nerve active? (y/n)\n");
 		scanf(" %s", activity);
		if(strcmp(activity, "y") == 0)
			n_fibres = 1.33798662;
		else if(strcmp(worg, "n") == 0)
			n_fibres = 1.338;
		else{
			printf("Invalid character.\n");
			exit(-1);
		}
		//Compute dielectric constants
		epsr_nerve = N_NERVE*N_NERVE;
	  epsr_fibres = n_fibres*n_fibres;
		epsr_endo = N_ENDO*N_ENDO;
		epsr_myelin = N_MYELIN*N_MYELIN;
	  epsr_ela = N_ELA*N_ELA;
		
	
		//read file containing the positions of the nerve fibres -- center positions (x,y) and radii
		read = fopen("filegrid.txt","r");
		for(i = 0; i<SIZE; i++){
			fscanf(read, "%d %d %d",&cx[i],&cy[i],&r[i]);
		}
		fclose(read);
	  
		out = fopen(dielectric, "wb");
 		/* set electric-field update coefficients */
 		for (mm=0; mm<SizeX; mm++){
  	  for (nn=0; nn<SizeY; nn++) {
				if( mm < X_NERVE){ //water
					Ceze(mm, nn) = 1.0;
					Cezh(mm, nn) = Cdtds*imp0 /  EPSR_WATER;
				}else if(mm >= X_NERVE && mm < X_FIBRES){ //endoneurium+perineurium
  	      if((mm>= 6950 && mm <7050) || (mm>= 7950 && mm<8050) || (mm>=8950 && mm<9050) ){ //elastic fibres
  	        Ceze(mm, nn) = 1.0;
					  Cezh(mm, nn) = Cdtds*imp0 /epsr_ela;
  	      }else{
  					Ceze(mm, nn) = 1.0;
		  			Cezh(mm, nn) = Cdtds*imp0 /epsr_nerve;
  	      }
				}else{
					for(j = 0; j<SIZE ;j++){
						xLocation = mm - cx[j];
						yLocation = nn - cy[j];
						r1 = r[j]-5;
						if(xLocation*xLocation + yLocation*yLocation <= r[j]*r[j]){//nerve fibres and their myelin sheath
							if(xLocation*xLocation + yLocation*yLocation <= r1*r1){
								Ceze(mm, nn) = 1.0;
								Cezh(mm, nn) = Cdtds*imp0 /epsr_fibres;
								break;
							}
							Ceze(mm, nn) = 1.0;
							Cezh(mm, nn) = Cdtds*imp0 /epsr_myelin;
							break;
							}
							else{
								Ceze(mm, nn) = 1.0;
								Cezh(mm, nn) = Cdtds*imp0 /epsr_endo;
							}
					}
				}
				temp = (float)Cezh(mm, nn);
				fwrite(&temp, sizeof(float), 1, out); // write the float
  	 }
		}
		fclose(out);
	}else if(strcmp(worg, "r") == 0){
		printf("You have chosen to simulate the reference arm.\n");
  	sprintf(dielectric,"dielectric_%1s",worg);
		out = fopen(dielectric, "wb");

  /* set electric-field update coefficients */
 		for (mm=0; mm<SizeX; mm++){
   		for (nn=0; nn<SizeY; nn++) {
				if( mm < X_NERVE){ //air
					Ceze(mm, nn) = 1.0;
					Cezh(mm, nn) = Cdtds*imp0;
				}else{//mirror
					Ceze(mm,nn) = 0.0;
       		Cezh(mm,nn) = 0.0;
				}
				temp = (float)Cezh(mm, nn);
				fwrite(&temp, sizeof(float), 1, out); // write the float
	   	}
		}
	fclose(out);

	}else{
		printf("Invalid character.\n");
		exit(-1);
	}

  /* set magnetic-field update coefficients */
  for (mm=0; mm<SizeX; mm++)
    for (nn=0; nn<SizeY-1; nn++) {
      Chxh(mm,nn) = 1.0;
      Chxe(mm,nn) = Cdtds/imp0;
    }

  for (mm=0; mm<SizeX-1; mm++)
    for (nn=0; nn<SizeY; nn++) {
      Chyh(mm,nn) = 1.0;
      Chye(mm,nn) = Cdtds/imp0;
    }

  return;
}
