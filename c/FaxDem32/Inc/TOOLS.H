/****************************************************************************/
/* tools.h   (c) Copyright Black Ice Software Inc.  1989 - 1991             */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/
#define NORM_BIT_ORDER   1			/* High to Low */
#define REV_BIT_ORDER    2			/* Low to High */

#define LH_BYTE_ORDER    0x4949 /* High to Low */
#define HL_BYTE_ORDER	   0x4D4D	/* Low to High */

// Type independent min and max macros.
#define MIN(A,B) ( (A < B) ? A : B )
#define MAX(A,B) ( (A > B) ? A : B )

typedef unsigned char huge * HPSTR;

