/*
 *  arraymatrix.h
 *
 *
 *  Created by Kristoffer Andersson on 10/10/05.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

/* Struct to hold an arraymatrix */
typedef struct
	{
		mwSignedIndex nrow;
		mwSignedIndex ncol;
		mwSignedIndex nelem;
		mwSignedIndex complex;
		double *data;
	} ArrayMatrix;

/* External API */
extern void amSetArrayMatrix(ArrayMatrix *A, double *data, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem, mwSignedIndex complex);
extern mwSignedIndex amIsScalar(ArrayMatrix A);
extern mwSignedIndex amIsComplex(ArrayMatrix A);
extern void amSolve(ArrayMatrix X, ArrayMatrix A, ArrayMatrix B);
extern void amInv(ArrayMatrix A);
extern void amMul(ArrayMatrix C, ArrayMatrix A, ArrayMatrix B);
extern void amPlus(ArrayMatrix C, ArrayMatrix A, ArrayMatrix B);
extern void amMinus(ArrayMatrix C, ArrayMatrix A, ArrayMatrix B);

/* Private subroutines */

/* addition */
void dplus(double *C, double *A, double *B, mwSignedIndex a_is_array, mwSignedIndex b_is_array, mwSignedIndex block_a, mwSignedIndex block_b, mwSignedIndex nelem, mwSignedIndex minus);
void zplus(double *C, double *A, double *B, mwSignedIndex a_is_array, mwSignedIndex b_is_array, mwSignedIndex block_a, mwSignedIndex block_b, mwSignedIndex nelem, mwSignedIndex minus);

/* multiplication */
void dsmul(double *C, double *A, double *B, mwSignedIndex a_is_array, mwSignedIndex b_is_array, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem);
void zsmul(double *C, double *A, double *B, mwSignedIndex a_is_array, mwSignedIndex b_is_array, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem);
void dgemul(double *C, double *A, double *B, mwSignedIndex a_is_array, mwSignedIndex b_is_array, mwSignedIndex np, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem);
void zgemul(double *C, double *A, double *B, mwSignedIndex a_is_array, mwSignedIndex b_is_array, mwSignedIndex np, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem);

/* inverse */
void d1inv(double *A, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem);
void z1inv(double *A, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem);
void d2inv(double *A, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem);
void z2inv(double *A, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem);
void dninv(double *A, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem);
void zninv(double *A, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem);

/* solve */
void dnsolve(double	*A, double	*B, mwSignedIndex a_is_array, mwSignedIndex b_is_array, mwSignedIndex n_a, mwSignedIndex ncol_b, mwSignedIndex nelem);
void znsolve(double	*A, double	*B, mwSignedIndex a_is_array, mwSignedIndex b_is_array, mwSignedIndex n_a, mwSignedIndex ncol_b, mwSignedIndex nelem);

/* utility */
mwSignedIndex intmax(mwSignedIndex a, mwSignedIndex b);







