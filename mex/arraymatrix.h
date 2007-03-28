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
		int nrow;
		int ncol;
		int nelem;
		int complex;
		double *data;
	} ArrayMatrix;

/* External API */
extern void amSetArrayMatrix(ArrayMatrix *A, double *data, int nrow, int ncol, int nelem, int complex);
extern int amIsScalar(ArrayMatrix A);
extern int amIsComplex(ArrayMatrix A);
extern void amSolve(ArrayMatrix X, ArrayMatrix A, ArrayMatrix B);
extern void amInv(ArrayMatrix A);
extern void amMul(ArrayMatrix C, ArrayMatrix A, ArrayMatrix B);
extern void amPlus(ArrayMatrix C, ArrayMatrix A, ArrayMatrix B);
extern void amMinus(ArrayMatrix C, ArrayMatrix A, ArrayMatrix B);

/* Private subroutines */ 

/* addition */
void dplus(double *C, double *A, double *B, int a_is_array, int b_is_array, int block_a, int block_b, int nelem, int minus);
void zplus(double *C, double *A, double *B, int a_is_array, int b_is_array, int block_a, int block_b, int nelem, int minus);

/* multiplication */
void dsmul(double *C, double *A, double *B, int a_is_array, int b_is_array, int nrow, int ncol, int nelem);
void zsmul(double *C, double *A, double *B, int a_is_array, int b_is_array, int nrow, int ncol, int nelem);
void dgemul(double *C, double *A, double *B, int a_is_array, int b_is_array, int np, int nrow, int ncol, int nelem);
void zgemul(double *C, double *A, double *B, int a_is_array, int b_is_array, int np, int nrow, int ncol, int nelem);

/* inverse */
void d1inv(double *A, int nrow, int ncol, int nelem);
void z1inv(double *A, int nrow, int ncol, int nelem);
void d2inv(double *A, int nrow, int ncol, int nelem);
void z2inv(double *A, int nrow, int ncol, int nelem);
void dninv(double *A, int nrow, int ncol, int nelem);
void zninv(double *A, int nrow, int ncol, int nelem);

/* solve */
void dnsolve(double	*A, double	*B, int a_is_array, int b_is_array, int n_a, int ncol_b, int nelem);
void znsolve(double	*A, double	*B, int a_is_array, int b_is_array, int n_a, int ncol_b, int nelem);

/* utility */
int intmax(int a, int b);

