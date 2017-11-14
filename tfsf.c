#include <string.h>  // for memcpy
#include "fdtd-macro.h"
#include "fdtd-proto2.h"
#include "fdtd-alloc1.h"
#include "ezinc.h"

static int firstX = 0, firstY, // indices for first point in TF region
           lastX, lastY;       // indices for last point in TF region
static double w1;

static Grid *g1;  // 1D auxilliary grid  /*@\label{tfsftmzC}@*/

void tfsfInit(Grid *g) {

  ALLOC_1D(g1, 1, Grid);       // allocate memory for 1D Grid
  memcpy(g1, g, sizeof(Grid)); // copy information from 2D array
  gridInit1d(g1);              // initialize 1d grid

  printf("Grid is %d by %d cell.\n", SizeX, SizeY);
  printf("Enter indices for first point in TF region: ");
  scanf(" %d %d", &firstX, &firstY);
  printf("Enter indices for last point in TF region: ");
  scanf(" %d %d", &lastX, &lastY);
  printf("Enter width of beam in y direction: ");
  scanf(" %lf", &w1);

  ezIncInit(g); // initialize source function

  return;
}

void tfsfUpdate(Grid *g) {
  int mm, nn;

  // check if tfsfInit() has been called
  if (firstX <= 0) {
    fprintf(stderr,
      "tfsfUpdate: tfsfInit must be called before tfsfUpdate.\n"
      "            Boundary location must be set to positive value.\n");
    exit(-1);
  }

  // correct Hy along left edge
  mm = firstX - 1;
  for (nn = firstY; nn <= lastY; nn++)
    Hy(mm, nn) -= Chye(mm, nn) * Ez1G(g1, mm + 1)*exp(-pow(((double)nn-(double)SizeY/2)/w1,2));
  
  // correct Hy along right edge
  mm = lastX;
  for (nn = firstY; nn <= lastY; nn++)
    Hy(mm, nn) += Chye(mm, nn) * Ez1G(g1, mm)*exp(-pow(((double)nn-(double)SizeY/2)/w1,2));

  // correct Hx along the bottom
  nn = firstY - 1;
  for (mm = firstX; mm <= lastX; mm++)
    Hx(mm, nn) += Chxe(mm, nn) * Ez1G(g1, mm)*exp(-pow(((double)nn-(double)SizeY/2)/w1,2));

  // correct Hx along the top
  nn = lastY;
  for (mm = firstX; mm <= lastX; mm++)
    Hx(mm, nn) -= Chxe(mm, nn) * Ez1G(g1, mm)*exp(-pow(((double)nn-(double)SizeY/2)/w1,2));

  updateH2d(g1);    // update 1D magnetic field
  updateE2d(g1);    // update 1D electric field
  Ez1G(g1, 0) = ezInc(TimeG(g1), 0.0); // set source node
  TimeG(g1)++;      // increment time in 1D grid

  /* correct Ez adjacent to TFSF boundary */
  // correct Ez field along left edge
  mm = firstX; 
  for (nn = firstY; nn <= lastY; nn++)
    Ez(mm, nn) -= Cezh(mm, nn) * Hy1G(g1, mm - 1)*exp(-pow(((double)nn-(double)SizeY/2)/w1,2));
  
  // correct Ez field along right edge
  mm = lastX;
  for (nn = firstY; nn <= lastY; nn++)
    Ez(mm, nn) += Cezh(mm, nn) * Hy1G(g1, mm)*exp(-pow(((double)nn-(double)SizeY/2)/w1,2));
  
  // no need to correct Ez along top and bottom since
  // incident Hx is zero

  return;
}
