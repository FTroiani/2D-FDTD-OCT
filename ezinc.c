#include "ezinc.h"

static double cdtds, ppw = 0, N_0, width;

/* initialize source-function variables */
void ezIncInit(Grid *g){

  printf("Enter the points per wavelength for source: ");
  scanf(" %lf", &ppw);
	printf("Enter the number of photons: ");
  scanf(" %lf", &N_0);
	printf(" Enter pulse width");
	scanf(" %lf", &width);
  cdtds = Cdtds;   /*@ \label{ezinc2DA} @*/
  return;
}

/* calculate source function at given time and location */
double ezInc(double time, double location) {
  double arg, phase;

  if (ppw <= 0) {
    fprintf(stderr,
       "ezInc: ezIncInit() must be called before ezInc.\n"
       "       Points per wavelength must be positive.\n");
    exit(-1);
  }

	arg = (time-3*width)/width;
	arg = arg*arg;
	phase = 2*M_PI/ppw*(cdtds*(time - 3*width) - location);

//  arg = M_PI * ((cdtds * time - location) / ppw - 1.0);
//  arg = arg * arg;

//  return sqrt(N_0)*(1.0 - 2.0 * arg) * exp(-arg);
	return sqrt(N_0)*exp(-arg)*sin(phase);

}
