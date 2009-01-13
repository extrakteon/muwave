/* $Revision$ $Date$ */
/*=========================================================
 * fort.h
 * header file for auxilliary routines for conversion
 * between MATLAB and FORTRAN complex data structures.
 *
 * Copyright 2006 Kristoffer Andersson
 *=======================================================*/

/*
 * Convert MATLAB complex matrix to Fortran complex storage.
 * Z = mat2fort(X) converts MATLAB's mxArray X to Fortran's
 * complex*16 Z.
 */

double* mat2fort(
    const mxArray *X
    );

/*
 * Convert Fortran complex storage to MATLAB real and imaginary parts.
 * X = fort2mat(Z,nrow,ncol,nelem) copies Z to X, producing a complex mxArray.
 */

mxArray* fort2mat(
    double *Z,
    int nrow,
    int ncol,
    int nelem
    );


