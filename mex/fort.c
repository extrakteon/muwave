/* $Revision:$ $Date:$ */
/*=========================================================
 * fort.c
 * auxilliary routines for conversion between MATLAB and
 * FORTRAN complex data structures.
 *
 * Copyright 2005 Kristoffer Andersson.
 *=======================================================*/
#include "mex.h"

/*
 * Convert MATLAB complex matrix to Fortran complex storage.
 * Z = mat2fort(X) converts MATLAB's mxArray X to Fortran's
 * complex*16 Z.
 */

double* mat2fort(
const mxArray *X
)
{
    int n, nelem, cmplxflag;
    double *Z, *xr, *xi, *zp;
    
    nelem = mxGetNumberOfElements(X);
    xr = mxGetPr(X);
    xi = mxGetPi(X);
    cmplxflag = (xi != NULL);
    Z = (double *) mxCalloc(2*nelem, sizeof(double));
    zp = Z; /* use zp as a temporary pointer, no risk of loosing Z! */
    if (cmplxflag) {
        /* Copy contents of real(X) and imaginary(X) to Z */
        for (n = 0; n < nelem; n++) {
            *zp++ = *xr++;
            *zp++ = *xi++;
        }
    } else {
        /* Copy contents of real(X) to Z, while keeping imag(Z) = 0 */
        for (n = 0; n < nelem; n++) {
            *zp++ = *xr++;
            *zp++; /* keep imag(Z) = 0 */
        }
    }
    return(Z);
}

/*
 * Convert Fortran complex storage to MATLAB real and imaginary parts.
 * X = fort2mat(Z,dim,size) copies Z to X, producing a complex mxArray.
 */

mxArray* fort2mat(
double *Z,
int nrow,
int ncol,
int nelem
)
{
    int n, dim, size[3];
    double *xr, *xi, *zp;
    mxArray *X;
    
    /* Don't create 3-D matrix if not absolutely necessary */
    size[0] = nrow;
    size[1] = ncol;
    if (nelem>1) {
        dim = 3;
        size[2] = nelem;
    } else {
        dim = 2;
        size[2] = 0;
    }
    
    /* Create complex MATLAB matrix */
    X = mxCreateNumericArray(dim, size, mxDOUBLE_CLASS, mxCOMPLEX); 
    xr = mxGetPr(X);
    xi = mxGetPi(X);
    zp = Z; /* use zp as a temporary pointer, no risk of loosing Z! */
    for (n = 0; n < (nrow*ncol*nelem); n++) {
        /* Copy contents of Z to real(X) and imag(X) */
        *xr++ = *zp++;
        *xi++ = *zp++;
    }
    return(X);
    
}
