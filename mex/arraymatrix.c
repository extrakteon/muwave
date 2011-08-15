/*
 *  arraymatrix.c
 *
 *
 *  Created by Kristoffer Andersson on 10/10/05.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#include <math.h>
#include "mex.h"
#include "matrix.h"
#include "arraymatrix.h"

#if defined(__OS2__) || defined(__WINDOWS__) || defined(WIN32) || defined(_MSC_VER)
#define BLASCALL(f) f
#else
#define BLASCALL(f) f ## _
#endif

/* Sets up a proper ArrayMatrix struct */
extern void amSetArrayMatrix(ArrayMatrix *A, double *data, mwSignedIndex nrow, mwSignedIndex ncol, mwSignedIndex nelem, mwSignedIndex complex)
{
	(*A).data = data;
	(*A).nrow = nrow;
	(*A).ncol = ncol;
	(*A).nelem = nelem;
	(*A).complex = complex;
}

/* return 1 if A is scalar. */
extern mwSignedIndex amIsScalar(ArrayMatrix A)
{
	return(((A.nrow == 1) && (A.ncol == 1)));
}

/* return 1 if A is complex */
extern mwSignedIndex amIsComplex(ArrayMatrix A)
{
	return(A.complex);
}

/* Solves AX=B */
extern void amSolve(ArrayMatrix X, ArrayMatrix A, ArrayMatrix B)
{
	mwSignedIndex n, nelem;
	mwSignedIndex block, stride, inc = 1;
	double *pB, *pX;

	nelem = intmax(A.nelem, B.nelem);

	if (A.complex || B.complex) {
		/* first copy B to X */
		pB = B.data;
		pX = X.data;
		if (B.nelem > 1) {
			block = nelem * B.nrow * B.ncol;
			BLASCALL(zcopy)(&block, pB, &inc, pX, &inc);
		} else {
			block = B.nrow * B.ncol;
			for (n = 0; n < nelem; n++) {
			  BLASCALL(zcopy)(&block, pB, &inc, pX, &inc);
			  pX += 2*block;
			}
		}
		znsolve(A.data, X.data, A.nelem > 1, 1, A.ncol, X.ncol, nelem);

	} else {
		pB = B.data;
		pX = X.data;
		if (B.nelem > 1) {
			block = nelem * B.nrow * B.ncol;
			BLASCALL(dcopy)(&block, pB, &inc, pX, &inc);
		} else {
			block = B.nrow * B.ncol;
			for (n = 0; n < nelem; n++) {
			  BLASCALL(dcopy)(&block, pB, &inc, pX, &inc);
				pX += block;
			}
		}

		dnsolve(A.data, X.data, A.nelem > 1, 1, A.ncol, X.ncol, nelem);

	}
}

/* Calculates inverse of matrix A */
extern void amInv(ArrayMatrix A)
{
	if (A.complex) {
		if (A.nrow > 2) {
			zninv(A.data,A.nrow,A.ncol,A.nelem);
		} else if (A.nrow == 2) {
			z2inv(A.data,A.nrow,A.ncol,A.nelem);
		} else {
			z1inv(A.data,A.nrow,A.ncol,A.nelem);
		}
	} else {
		if (A.nrow > 2) {
			dninv(A.data,A.nrow,A.ncol,A.nelem);
		} else if (A.nrow == 2) {
			d2inv(A.data,A.nrow,A.ncol,A.nelem);
		} else {
			d1inv(A.data,A.nrow,A.ncol,A.nelem);
		}
	}
}

/* Matrix multiplication C = A * B */
extern void amMul(ArrayMatrix C, ArrayMatrix A, ArrayMatrix B)
{
	mwSignedIndex np, nrow, ncol, nelem;

	/* Number of elements */
	nelem = intmax(A.nelem, B.nelem);

	/* Check if any of the arguments are a scalar */
	if (amIsScalar(A)) {
		/* Call scalar multiplication with A and B interchanged */
		nrow = B.nrow;
		ncol = B.ncol;
		if (A.complex || B.complex) {
			/* Complex multiplication */
			zsmul(C.data, B.data, A.data, B.nelem > 1, A.nelem > 1, nrow, ncol, nelem);
		} else {
			/* Real multiplication */
			dsmul(C.data, B.data, A.data, B.nelem > 1, A.nelem > 1, nrow, ncol, nelem);
		}
	} else if (amIsScalar(B)) {
		nrow = A.nrow;
		ncol = A.ncol;
		if (A.complex || B.complex) {
			/* Complex multiplication */
			zsmul(C.data, A.data, B.data, A.nelem > 1, B.nelem > 1, nrow, ncol, nelem);
		} else {
			/* Real multiplication */
			dsmul(C.data, A.data, B.data, A.nelem > 1, B.nelem > 1, nrow, ncol, nelem);
		}
	} else {
		nrow = A.nrow;
		ncol = B.ncol;
		np = A.ncol;
		if (A.complex || B.complex) {
			/* Complex multiplication */
			zgemul(C.data, A.data, B.data, A.nelem > 1, B.nelem > 1, np, nrow, ncol, nelem);
		} else {
			/* Real multiplication */
			dgemul(C.data, A.data, B.data, A.nelem > 1, B.nelem > 1, np, nrow, ncol, nelem);
		}
	}

}

/* Matrix addition C = A + B */
extern void amPlus(ArrayMatrix C, ArrayMatrix A, ArrayMatrix B)
{
	mwSignedIndex nelem;

	/* Number of elements */
	nelem = intmax(A.nelem, B.nelem);

	if (A.complex || B.complex) {
		zplus(C.data, A.data, B.data, A.nelem > 1, B.nelem > 1, A.nrow*A.ncol, B.nrow*B.ncol, nelem, 0);
	} else {
		dplus(C.data, A.data, B.data, A.nelem > 1, B.nelem > 1, A.nrow*A.ncol, B.nrow*B.ncol, nelem, 0);
	}

}

/* Matrix subtraction C = A - B */
extern void amMinus(ArrayMatrix C, ArrayMatrix A, ArrayMatrix B)
{
	mwSignedIndex nelem;

	/* Number of elements */
	nelem = intmax(A.nelem, B.nelem);

	if (A.complex || B.complex) {
		zplus(C.data, A.data, B.data, A.nelem > 1, B.nelem > 1, A.nrow*A.ncol, B.nrow*B.ncol, nelem, 1);
	} else {
		dplus(C.data, A.data, B.data, A.nelem > 1, B.nelem > 1, A.nrow*A.ncol, B.nrow*B.ncol, nelem, 1);
	}

}

/* subroutine for addition of two complex array matrices using ZAXPY */
void dplus(
				   double	*C,
				   double	*A,
				   double	*B,
				   mwSignedIndex a_is_array,
				   mwSignedIndex b_is_array,
				   mwSignedIndex block_a,
				   mwSignedIndex block_b,
				   mwSignedIndex nelem,
				   mwSignedIndex minus
				   )
{
	double *pA, *pB, *pC;
	mwSignedIndex n;
	mwSignedIndex stride_a, stride_b;
	mwSignedIndex inca = 1, incb = 1, incc = 1;
	double alpha = 1.0;
	mwSignedIndex block;

	if (minus) alpha = -1.0;

	stride_a = block_a * a_is_array;
	stride_b = block_b * b_is_array;

	pA = A; pB = B; pC = C;
	if ((stride_a > 0) & (stride_a == stride_b)) {
		/* Both are matrices and both are arrays */
		block = stride_a * nelem;
		/* first copy A to C */
		BLASCALL(dcopy)(&block, pA, &inca, pC, &incc);
		/* then add alpha*B to C */
		BLASCALL(daxpy)(&block, &alpha, pB, &incb, pC, &incc);
	} else {
		block = intmax(block_a, block_b);
		/* set increment to 0 if scalar */
		inca = block_a > 1;
		incb = block_b > 1;
		for (n = 0; n < nelem; n++) {
			/* first copy A to C */
		        BLASCALL(dcopy)(&block, pA, &inca, pC, &incc);
			/* then add alpha*B to C */
			BLASCALL(daxpy)(&block, &alpha, pB, &incb, pC, &incc);
			pA += stride_a;
			pB += stride_b;
			pC += block;
		}
	}
}

/* subroutine for addition of two complex array matrices using DAXPY */
void zplus(
				   double	*C,
				   double	*A,
				   double	*B,
				   mwSignedIndex a_is_array,
				   mwSignedIndex b_is_array,
				   mwSignedIndex block_a,
				   mwSignedIndex block_b,
				   mwSignedIndex nelem,
				   mwSignedIndex minus
				   )
{
	double *pA, *pB, *pC;
	mwSignedIndex n;
	mwSignedIndex stride_a, stride_b;
	mwSignedIndex inca = 1, incb = 1, incc = 1;
	double alpha[2];
	mwSignedIndex block;

	alpha[0] = 1.0; alpha[1] = 0.0;
	if (minus) alpha[0] = -1.0;

	stride_a = block_a * a_is_array;
	stride_b = block_b * b_is_array;

	pA = A; pB = B; pC = C;
	if ((stride_a > 0) & (stride_a == stride_b)) {
		/* Both are matrices and both are arrays */
		block = stride_a * nelem;
		/* first copy A to C */
		BLASCALL(zcopy)(&block, pA, &inca, pC, &incc);
		/* then add alpha*B to C */
		BLASCALL(zaxpy)(&block, &alpha, pB, &incb, pC, &incc);
	} else {
		block = intmax(block_a, block_b);
		/* set increment to 0 if scalar */
		inca = block_a > 1;
		incb = block_b > 1;
		for (n = 0; n < nelem; n++) {
			/* first copy A to C */
		        BLASCALL(zcopy)(&block, pA, &inca, pC, &incc);
			/* then add alpha*B to C */
			BLASCALL(zaxpy)(&block, &alpha, pB, &incb, pC, &incc);
			pA += 2*stride_a;
			pB += 2*stride_b;
			pC += 2*block;
		}
	}
}

/* subroutine for multiplication of two real array matrices using DGEMM */
void dgemul(
				   double	*C,
				   double	*A,
				   double	*B,
				   mwSignedIndex a_is_array,
				   mwSignedIndex b_is_array,
				   mwSignedIndex np,
				   mwSignedIndex nrow,
				   mwSignedIndex ncol,
				   mwSignedIndex nelem
				   )
{

	mwSignedIndex M, N, K, LDA, LDB, LDC;
	mwSignedIndex n, stride_a, stride_b, stride_c;
	double alpha = 1.0, beta = 0.0;
	double *pA, *pB, *pC;
	char *chn = "N";

	M = nrow;
	N = ncol;
	K = np;
	LDA = nrow;
	LDB = np;
	LDC = nrow;

	/* Set stride to zero if we have 2D matrices */
    stride_a = nrow * np * a_is_array;
    stride_b = np * ncol * b_is_array;
    /* Set stride_c > 0. This is a hidden feature allowing filling of a 3D matrix from 2D arguments */
    stride_c = ncol * nrow;

	for (n=0; n < nelem; n++) {
		pA = A + n*stride_a;
		pB = B + n*stride_b;
		pC = C + n*stride_c;
		BLASCALL(dgemm)(chn, chn, &M, &N, &K, &alpha, pA, &LDA, pB, &LDB, &beta, pC, &LDC);
	}

}

/* subroutine for multiplication of two complex array matrices using ZGEMM */
void zgemul(
				   double	*C,
				   double	*A,
				   double	*B,
				   mwSignedIndex a_is_array,
				   mwSignedIndex b_is_array,
				   mwSignedIndex np,
				   mwSignedIndex nrow,
				   mwSignedIndex ncol,
				   mwSignedIndex nelem
				   )
{

	mwSignedIndex M, N, K, LDA, LDB, LDC;
	mwSignedIndex n, stride_a, stride_b, stride_c;
	double alpha[2], beta[2];
	double *pA, *pB, *pC;
	char *chn = "N";

	/* Init scalars */
	alpha[0] = 1.0; alpha[1] = 0.0;
	beta[0] = 0.0; beta[1] = 0.0;

	M = nrow;
	N = ncol;
	K = np;
	LDA = nrow;
	LDB = np;
	LDC = nrow;

	/* Set stride to zero if we have 2D matrices */
    stride_a = 2 * nrow * np * a_is_array;
    stride_b = 2 * np * ncol * b_is_array;
    /* Set stride_c > 0. This is a hidden feature allowing filling of a 3D matrix from 2D arguments */
    stride_c = 2 * ncol * nrow;

	for (n=0; n < nelem; n++) {
		pA = A + n*stride_a;
		pB = B + n*stride_b;
		pC = C + n*stride_c;
		BLASCALL(zgemm)(chn, chn, &M, &N, &K, &alpha, pA, &LDA, pB, &LDB, &beta, pC, &LDC);
	}

}


/* subroutine for multiplication of a complex array matrix and a complex scalar array using DAXPY */
void dsmul(
		   double	*C,
		   double	*A,
		   double	*B,
		   mwSignedIndex a_is_array,
		   mwSignedIndex b_is_array,
		   mwSignedIndex nrow,
		   mwSignedIndex ncol,
		   mwSignedIndex nelem
		   )
{
	double *pC, *pA, *pB;
    mwSignedIndex n, block;
	mwSignedIndex incx = 1, incy = 1;
	mwSignedIndex stride_a, stride_c;

	stride_a = nrow * ncol * a_is_array;
	stride_c = nrow * ncol;

    /* Perform multiplication */
	pA = A; pB = B; pC = C;
	if (b_is_array) {
		block = nrow * ncol; /* essential the same as stride_c */
		for (n = 0; n < nelem; n++) {
		        BLASCALL(daxpy)(&block, pB, pA, &incx, pC, &incy);
			pA += stride_a;
			pC += stride_c;
			pB++;
		}
    } else {
		block = nrow * ncol * nelem;
		BLASCALL(daxpy)(&block, pB, pA, &incx, pC, &incy);
	}
    return;
}

/* subroutine for multiplication of a complex array matrix and a complex scalar array using ZAXPY */
void zsmul(
		   double	*C,
		   double	*A,
		   double	*B,
		   mwSignedIndex a_is_array,
		   mwSignedIndex b_is_array,
		   mwSignedIndex nrow,
		   mwSignedIndex ncol,
		   mwSignedIndex nelem
		   )
{
	double *pC, *pA, *pB;
    mwSignedIndex n, block;
	mwSignedIndex incx = 1, incy = 1;
	mwSignedIndex stride_a, stride_c;

	stride_a = 2 * nrow * ncol * a_is_array;
	stride_c = 2 * nrow * ncol;

    /* Perform multiplication */
	pA = A; pB = B; pC = C;
	if (b_is_array) {
		block = nrow * ncol; /* essential the same as stride_c */
		for (n = 0; n < nelem; n++) {
		        BLASCALL(zaxpy)(&block, pB, pA, &incx, pC, &incy);
			pA += stride_a;
			pC += stride_c;
			pB += 2;
		}
    } else {
		block = nrow * ncol * nelem;
		BLASCALL(zaxpy)(&block, pB, pA, &incx, pC, &incy);
	}
    return;
}

/* Subroutine for inverting a 1x1xN real "matrix" */
void d1inv(
		   double	*A,
		   mwSignedIndex nrow,
		   mwSignedIndex ncol,
		   mwSignedIndex nelem
		   )
{
    mwSignedIndex n, pn;
    double r11;

	for (n = 0; n < nelem; n++) {

		r11 = *(A + n);
		/* Calculate inverse */
        *(A + n) = 1/r11;

    }
    return;
}

/* Subroutine for inverting a 1x1xN complex "matrix" */
void z1inv(
		   double	*A,
		   mwSignedIndex nrow,
		   mwSignedIndex ncol,
		   mwSignedIndex nelem
		   )
{
    mwSignedIndex n, pn;
    double r11;
	double i11;
	double alpha;

	pn = 0;
    for (n = 0; n < nelem; n++) {

		r11 = *(A + pn);
		i11 = *(A + pn + 1);

		/* Calculate inverse */
        alpha = 1./(r11*r11 + i11*i11);
        *(A + pn) = r11*alpha;
        *(A + pn + 1) = -i11*alpha;

		/* go to next block */
		pn += 2;

    }
    return;
}


/* Subroutine for inverting a 2x2xN real matrix */
void d2inv(
		   double	*A,
		   mwSignedIndex nrow,
		   mwSignedIndex ncol,
		   mwSignedIndex nelem
		   )
{
	mwSignedIndex n, pn;
    double r11,r21,r12,r22;
	double idr;

	pn = 0;
    for (n = 0; n < nelem; n++) {

		r11 = *(A + pn);
		r21 = *(A + pn + 1);
		r12 = *(A + pn + 2);
		r22 = *(A + pn + 3);

        /* Calculate inverse determinant */
        idr = 1/(r11*r22 - r21*r12);

		/* Perform inversion using Cramers' rule */
		*(A + pn) = r22*idr;
        *(A + pn + 1) = - r21*idr;
        *(A + pn + 2) = -r12*idr;
        *(A + pn + 3) = r11*idr;

		pn += 4;

	}
    return;
}

/* Subroutine for inverting a 2x2xN complex matrix */
void z2inv(
		   double	*A,
		   mwSignedIndex nrow,
		   mwSignedIndex ncol,
		   mwSignedIndex nelem
		   )
{
    mwSignedIndex n, pn;
    double r11,r21,r12,r22;
	double i11,i21,i12,i22;
	double rdet, idet;
    double alpha;

	pn = 0;
    for (n = 0; n < nelem; n++) {

		r11 = *(A + pn);
		i11 = *(A + pn + 1);
		r21 = *(A + pn + 2);
		i21 = *(A + pn + 3);
		r12 = *(A + pn + 4);
		i12 = *(A + pn + 5);
		r22 = *(A + pn + 6);
		i22 = *(A + pn + 7);

        /* Calculate determinant */
        rdet = r11*r22 - i11*i22 - r21*r12 + i21*i12;
		idet = r11*i22 + i11*r22 - r21*i12 - i21*r12;

		/* Calculate inverse determinant */
        alpha = 1./(rdet*rdet + idet*idet);
        rdet = rdet*alpha;
        idet = -idet*alpha;

		/* Perform inversion using Cramers' rule */
		*(A + pn) = r22*rdet - i22*idet;
        *(A + pn + 1) = i22*rdet + r22*idet;
		*(A + pn + 2) = -r21*rdet + i21*idet;
        *(A + pn + 3) = -i21*rdet - r21*idet;
		*(A + pn + 4) = -r12*rdet + i12*idet;
        *(A + pn + 5) = -i12*rdet - r12*idet;
		*(A + pn + 6) = r11*rdet - i11*idet;
		*(A + pn + 7) = i11*rdet + r11*idet;

		pn += 8;

    }
    return;
}


/* Subroutine for inverting a nxnxN real matrix using LAPACK */
void dninv(
		   double	*A,
		   mwSignedIndex nrow,
		   mwSignedIndex ncol,
		   mwSignedIndex nelem
		   )
{

	mwSignedIndex *ipiv, info, lwork; /* LAPACK specific variables */
	double *work, *work_init;

	double *pA;
	mwSignedIndex n, block;

	/* Allocate memory for pivot elements */
	ipiv = (mwSignedIndex *)malloc(nrow * sizeof(mwSignedIndex));

    /* Loop through array */
    block = nrow*ncol;
	pA = A;
	for (n = 0; n < nelem; n++) {
		info = 0;

		/* Real LU factorization */
		BLASCALL(dgetrf)( &nrow, &nrow, pA, &nrow, ipiv, &info);

		/* Query and allocate about optimum size of WORK */
		if (n == 0) {
			info = 0;
			lwork = -1;
			work_init = (double *)calloc(2, sizeof(double)); /* FIXME: shift to static allocation */
			BLASCALL(dgetri)( &nrow, pA, &nrow, ipiv, work_init, &lwork, &info);
			/* Allocate optimum WORK storage */
			lwork = (mwSignedIndex)(work_init[0]);
			work = (double *)calloc(lwork, sizeof(double));
		}

        	/* Real inverse */
		BLASCALL(dgetri)( &nrow, pA, &nrow, ipiv, work, &lwork, &info);

		/* work on matrix n */
		pA += block;

    }

	/* Free dynamic memory */
	free(ipiv);
	free(work_init);
	free(work);

}

/* Subroutine for inverting a nxnxN complex matrix using LAPACK */
void zninv(
		   double	*A,
		   mwSignedIndex nrow,
		   mwSignedIndex ncol,
		   mwSignedIndex nelem
		   )
{

	mwSignedIndex *ipiv, info, lwork; /* LAPACK specifik variables */
	double *work, *work_init;

	double *pA;
	mwSignedIndex n, block;

	/* Allocate memory for pivot elements */
	ipiv = (mwSignedIndex *)calloc(nrow, sizeof(mwSignedIndex));

    /* Loop through array */
	block = 2*nrow*ncol;
	pA = A;
    for (n = 0; n < nelem; n++) {
 		info = 0;

		/* Complex LU factorization */
		BLASCALL(zgetrf)( &nrow, &nrow, pA, &nrow, ipiv, &info);

		/* Query and allocate about optimum size of WORK */
		if (n == 0) {
			info = 0;
			lwork = -1;
			work_init = (double *)calloc(2, sizeof(double)); /* FIXME: shift to static allocation */
			BLASCALL(zgetri)( &nrow, pA, &nrow, ipiv, work_init, &lwork, &info);
			/* Allocate optimum WORK storage */
			lwork = (mwSignedIndex)(work_init[0]);
			work = (double *)calloc(2*lwork, sizeof(double));
		}

        /* Complex inverse */
		BLASCALL(zgetri)( &nrow, pA, &nrow, ipiv, work, &lwork, &info);

		/* Work on matrix n */
		pA += block;

    }

	/* Free dynamic memory */
	free(ipiv);
	free(work_init);
	free(work);

}

/* Subroutine for solving AX=B using LAPACK */
void dnsolve(
		   double	*A,
		   double	*B,
		   mwSignedIndex a_is_array,
		   mwSignedIndex b_is_array,
		   mwSignedIndex n_a,
		   mwSignedIndex ncol_b,
		   mwSignedIndex nelem
		   )
{

	mwSignedIndex *ipiv, info = 0; /* LAPACK specific variables */
	char *chn = "N";

	double *pA, *pB;
	mwSignedIndex n, block_a, block_b;

	/* Allocate memory for pivot elements */
	ipiv = (mwSignedIndex *)malloc(n_a * sizeof(mwSignedIndex));

    	/* Loop through array */
    	block_a = n_a * n_a * a_is_array;
	block_b = n_a * ncol_b; /* Since B also holds the result, this block must be > 0 */
	pA = A;
	pB = B;
	if (a_is_array) {
		for (n = 0; n < nelem; n++) {

			/* Real LU factorization */
		        BLASCALL(dgetrf)( &n_a, &n_a, pA, &n_a, ipiv, &info);

			/* triangular solve */
			BLASCALL(dgetrs)( chn, &n_a, &ncol_b, pA, &n_a, ipiv, pB, &n_a, &info);

			/* work on matrix n */
			pA += block_a;
			pB += block_b;
		}

    } else {

		/* Real LU factorization */
	        BLASCALL(dgetrf)( &n_a, &n_a, pA, &n_a, ipiv, &info);

		for (n = 0; n < nelem; n++) {

			/* triangular solve */
		        BLASCALL(dgetrs)( chn, &n_a, &ncol_b, pA, &n_a, ipiv, pB, &n_a, &info);

			/* work on matrix n */
			pB += block_b;
		}
	}

	/* Free dynamic memory */
	free(ipiv);

}

/* Subroutine for solving AX=B (complex) using LAPACK */
void znsolve(
		   double	*A,
		   double	*B,
		   mwSignedIndex a_is_array,
		   mwSignedIndex b_is_array,
		   mwSignedIndex n_a,
		   mwSignedIndex ncol_b,
		   mwSignedIndex nelem
		   )
{

	mwSignedIndex *ipiv, info = 0; /* LAPACK specific variables */
	char *chn = "N";

	double *pA, *pB;
	mwSignedIndex n, block_a, block_b;

	/* Allocate memory for pivot elements */
	ipiv = (mwSignedIndex *)malloc(n_a * sizeof(mwSignedIndex));

    	/* Loop through array */
    	block_a = 2 * n_a * n_a * a_is_array;
	block_b = 2 * n_a * ncol_b; /* Since B also holds the result, this block must be > 0 */
	pA = A;
	pB = B;
	if (a_is_array) {
		for (n = 0; n < nelem; n++) {

			/* Complex LU factorization */
		        BLASCALL(dgetrf)( &n_a, &n_a, pA, &n_a, ipiv, &info);

			/* triangular solve */
			BLASCALL(dgetrs)( chn, &n_a, &ncol_b, pA, &n_a, ipiv, pB, &n_a, &info);

			/* work on matrix n */
			pA += block_a;
			pB += block_b;
		}

    } else {

		/* Complex LU factorization */
	        BLASCALL(zgetrf)( &n_a, &n_a, pA, &n_a, ipiv, &info);

		for (n = 0; n < nelem; n++) {

			/* triangular solve */
		        BLASCALL(zgetrs)( chn, &n_a, &ncol_b, pA, &n_a, ipiv, pB, &n_a, &info);

			/* work on matrix n */
			pB += block_b;
		}
	}
	/* Free dynamic memory */
	free(ipiv);

}

/* int max function */
mwSignedIndex intmax(
		   mwSignedIndex a,
		   mwSignedIndex b
		   )
{
	if (a > b) {
		return(a);
		} else {
		return(b);
		}
}

