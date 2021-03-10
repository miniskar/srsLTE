#include <stdio.h>
#include "AEEStdErr.h"
#include "brisbanehxg.h"
#include <brisbane/brisbane_hexagon_imp.h>

AEEResult brisbanehxg_saxpy(float* Z, int Zlen, const float A, const float* X, int XLen, const float* Y, int YLen, BRISBANE_HEXAGON_KERNEL_ARGS)
{
  int32 i = 0;
  BRISBANE_HEXAGON_KERNEL_BEGIN(i)
    Z[i] = A * X[i] + Y[i];
  BRISBANE_HEXAGON_KERNEL_END
  return AEE_SUCCESS;
}

