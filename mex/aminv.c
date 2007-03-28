/* $Revision: $ $Date: $ */
/*=========================================================
 * aminv.c
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
        
    int n, nrow, ncol, nelem;
    int cplx = -1;
    double *A, *pm;
    const int *size;
    int dim;
    int rowcol;
    mxArray *mxTemp;
    ArrayMatrix am;
	
    if ((nlhs > 1) || (nrhs != 1)) {
        mexErrMsgTxt("Expect 1 input argument and return 1 output argument");
    }
    
    /* Check the dimensions of M. */
    dim = mxGetNumberOfDimensions(prhs[0]);
    size = mxGetDimensions(prhs[0]);
    nrow = size[0];
    ncol = size[1];
    nelem = mxGetNumberOfElements(prhs[0])/(size[0]*size[1]);
    if (nrow != ncol) {
        mexErrMsgTxt("Matrix must be square.");
    }
	
    cplx = mxIsComplex(prhs[0]);
    if (cplx) {
		/* Convert matrix to Fortran complex and copies data to A */
		A = mat2fort(prhs[0]);
	} else {
      /* Copy input matrix to A */
        mxTemp = mxCreateNumericArray(dim, size, mxDOUBLE_CLASS, mxREAL);
        A = mxGetPr(mxTemp);
        pm = mxGetPr(prhs[0]);
        for (n = 0; n < nrow*ncol*nelem; n++) {
            A[n] = pm[n];
		}
	}

	amSetArrayMatrix(&am, A, nrow, ncol, nelem, cplx);
	
	/* Invert matrix */				
	amInv(am);
	
	if (cplx) {
		/* Convert to MATLAB complex */
		plhs[0] = fort2mat(A, nrow, ncol, nelem);
		mxFree(A); /* fort2mat copies content */
	} else {	
		/* Transfer output to MATLAB */
		plhs[0] = mxTemp;
    }
    
}
