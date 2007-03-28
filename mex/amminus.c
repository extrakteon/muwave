/* $Revision: $ $Date: $ */
/*=========================================================
 * amminus.c
 *
 *
 * This is a MEX-file for MATLAB.
 * Copyright 2005 Kristoffer Andersson
 *=======================================================*/
 
#include <math.h>
#include "mex.h"
#include "fort.h"
#include "arraymatrix.h"

void mexFunction( int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[] )

{
    double *C, *A, *B;
    mxArray *mxTemp;
	
    int dim_a, dim_b, dim_c;
    const int  *size_a, *size_b;
    int size_c[3];
    int complex = -1;
    int ncol, nrow;
    int nelem_a,nelem_b,nelem;
	
	ArrayMatrix amC, amA, amB;
    
    /* Check for proper number of arguments */
    
    if (nrhs != 2) {
        mexErrMsgTxt("Two input arguments required.");
    } else if (nlhs > 1) {
        mexErrMsgTxt("Too many output arguments.");
    }
    
    /* Get dimensions of A & B. */
    dim_a = mxGetNumberOfDimensions(prhs[0]);
    size_a = mxGetDimensions(prhs[0]);
    dim_b = mxGetNumberOfDimensions(prhs[1]);
    size_b = mxGetDimensions(prhs[1]);
    
    /* Check how deep the third dimension is */
    nelem_a = mxGetNumberOfElements(prhs[0])/(size_a[0]*size_a[1]);
    nelem_b = mxGetNumberOfElements(prhs[1])/(size_b[0]*size_b[1]);
    if (nelem_a == nelem_b) {
        nelem = nelem_a;
    } else if (nelem_a == 1) {
        nelem = nelem_b;
    } else if (nelem_b == 1) {
        nelem = nelem_a;
	} else {
        mexErrMsgTxt("Length of arguments must agree.");
    }
    
    /* Check dimensions of arguments */
    if ((size_a[0] == size_b[0]) && (size_a[1] == size_b[1])  ) {
        nrow = size_a[0];
        ncol = size_a[1];
    } else if ((size_a[0] == 1) && (size_a[1] == 1)) {
        /* A is a scalar */
        nrow = size_b[0];
        ncol = size_b[1];
    } else if ((size_b[0] == 1) && (size_b[1] == 1)) {
        /* B is a scalar */
        nrow = size_a[0];
        ncol = size_a[1];
    } else {
        mexErrMsgTxt("Matrix dimensions must agree.");
    }
    
    /* Calculate dimensions of output matrix */
    size_c[0] = nrow;
    size_c[1] = ncol;
    if (nelem > 1) {
        size_c[2] = nelem;
        dim_c = 3;
    } else {
        size_c[2] = 0;
        dim_c = 2;
    }
    
    /* Check if arguments are complex. */
    complex = (mxIsComplex(prhs[0]) || mxIsComplex(prhs[1]));
    
	if (complex) {
		/* Convert to FORTRAN style complex format */
		C = mxCalloc(2*nrow*ncol*nelem,sizeof(double));
		A = mat2fort(prhs[0]);
		B = mat2fort(prhs[1]);
	} else {
		mxTemp = mxCreateNumericArray(dim_c, size_c, mxDOUBLE_CLASS, mxREAL);
		C = mxGetPr(mxTemp);
		A = mxGetPr(prhs[0]);
		B = mxGetPr(prhs[1]); 
	}
	
	/* Assign values to arraymatrices */
	amSetArrayMatrix(&amC, C, size_c[0], size_c[1], nelem, complex);
	amSetArrayMatrix(&amA, A, size_a[0], size_a[1], nelem_a, complex);
	amSetArrayMatrix(&amB, B, size_b[0], size_b[1], nelem_b, complex);
	
	/* perform matrix addition */
	amMinus(amC, amA, amB);
	
    /* Create a matrix for the return argument and assign pointers */
    if (complex) {
		mxFree(A);
		mxFree(B);
		plhs[0] = fort2mat(C, nrow, ncol, nelem);
		mxFree(C);
    } else {
		plhs[0] = mxTemp;
    }
    
    return;
    
}


