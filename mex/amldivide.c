/* $Revision$ $Date$ */
/*=========================================================
 * amldivide.c
 *
 *
 * This is a MEX-file for MATLAB.
 * Copyright 2005 Kristoffer Andersson
 *=======================================================*/
#include "mex.h"
#include "fort.h"
#include "arraymatrix.h"

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
        
    int n, nelem;
	int nrow_a, ncol_a, nelem_a;
	int nrow_b, ncol_b, nelem_b;
    int cplx = -1;
    double *A, *B, *X, *pA;
    const int *size_a, *size_b;
	int size_x[3] = {0};
    int dim_a, dim_b, dim_x = 3;
    mxArray *mxTemp;
    ArrayMatrix amA, amB, amX;
	
    if ((nlhs > 1) || (nrhs != 2)) {
        mexErrMsgTxt("Expect 2 input arguments and return 1 output argument");
    }
    
    /* Check the dimensions of A. */
    dim_a = mxGetNumberOfDimensions(prhs[0]);
    size_a = mxGetDimensions(prhs[0]);
	nrow_a = size_a[0];
    ncol_a = size_a[1];
    nelem_a = mxGetNumberOfElements(prhs[0])/(ncol_a*nrow_a);
    if (nrow_a != ncol_a) {
        mexErrMsgTxt("Matrix A must be square.");
    }
	
	/* Check the dimensions of B. */
	dim_b = mxGetNumberOfDimensions(prhs[1]);
    size_b = mxGetDimensions(prhs[1]);
	nrow_b = size_b[0];
    ncol_b = size_b[1];
    nelem_b = mxGetNumberOfElements(prhs[1])/(ncol_b*nrow_b);
    if (ncol_a != nrow_b) {
		mexErrMsgTxt("Matrix dimensions must agree.");
	}
	
	if (!((nelem_a == 1) || (nelem_b == 1) || (nelem_a == nelem_b))) {
		mexErrMsgTxt("Array dimensions must agree.");
	}
	
	nelem = intmax(nelem_a, nelem_b);
	
    cplx = mxIsComplex(prhs[0]) || mxIsComplex(prhs[1]);
    if (cplx) {
		/* Convert matrix to Fortran complex and copies data to A & B*/
		A = mat2fort(prhs[0]);
		B = mat2fort(prhs[1]);
		/* Allocate storage for output */
		X = mxCalloc(2*nrow_a*ncol_b*nelem, sizeof(double));
		
	} else {
		/* since LAPACK alters A we have to make a copy */
		pA = mxGetPr(prhs[0]);
		A = mxMalloc(nrow_a*ncol_a*nelem_a * sizeof(double));
		for (n = 0; n < (nrow_a*ncol_a*nelem_a); n++) {
			A[n] = pA[n];
		}
		B = mxGetPr(prhs[1]);
		/* Allocate storage for output */
		X = mxMalloc(nrow_a*ncol_b*nelem*sizeof(double));
	}

	amSetArrayMatrix(&amA, A, nrow_a, ncol_a, nelem_a, cplx);
	amSetArrayMatrix(&amB, B, nrow_b, ncol_b, nelem_b, cplx);
	amSetArrayMatrix(&amX, X, nrow_b, ncol_b, nelem, cplx);
	
	/* Solve AX=B */				
	amSolve(amX, amA, amB);
		
	if (cplx) {
		/* Convert to MATLAB complex */
		plhs[0] = fort2mat(X, nrow_b, ncol_b, nelem);
		mxFree(X); /* fort2mat copies content */
	} else {	
		/* Transfer output to MATLAB */
		plhs[0] = mxCreateNumericArray(dim_x, size_x, mxDOUBLE_CLASS, mxREAL);
		size_x[0] = size_b[0];
		size_x[1] = size_b[1];
		size_x[2] = nelem;
		mxSetDimensions(plhs[0],size_x, dim_x);
		mxSetPr(plhs[0], X);
    }
	//mxFree(A);
    
}
