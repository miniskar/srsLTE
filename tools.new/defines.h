#ifndef __srslte_defines_h_
#define __srslte_defines_h_

#ifdef __cplusplus
#include <array>
#endif
        
#define index(x, y) strchr(x,y)
#define vsetq_lane_s32_old(X, Y, Z)  (X)
#define vsetq_lane_s16_old(X, Y, Z)  (X)
#define vgetq_lane_s32_old(X, Y)  (X)
#define vgetq_lane_s16_old(X, Y)  (X)

#define vshuff_s32_even(a, imm, res) \
  *(res) = vsetq_lane_s32(vgetq_lane_s32((a), ((imm) >> 2) & 0x3), *(res), 1); \
  *(res) = vsetq_lane_s32(vgetq_lane_s32((a), ((imm) >> 6) & 0x3), *(res), 3);
#define vshuff_s32_odd(a, imm, res) \
  *(res) = vsetq_lane_s32(vgetq_lane_s32((a), (imm)&0x3), *(res), 0); \
  *(res) = vsetq_lane_s32(vgetq_lane_s32((a), ((imm) >> 4) & 0x3), *(res), 2); 
#define vshuff_s32_idx(a, imm, res, idx) \
  *(res) = vsetq_lane_s32(vgetq_lane_s32((a), ((imm) >> ((idx) * 2)) & 0x3), *(res), (idx)); 
#define vshuff_s16_idx(a, imm, res, idx) \
  *(res) = vsetq_lane_s16(vgetq_lane_s16((a), ((imm) >> ((idx) * 4)) & 0xF), *(res), (idx)); 

#define vshuff_s16_even(a, imm, res) \
  *res = vsetq_lane_s16(vgetq_lane_s16((a), ((imm) >> 4) & 0xF), *res, 1); \
  *res = vsetq_lane_s16(vgetq_lane_s16((a), ((imm) >> 12) & 0xF), *res, 3); \
  *res = vsetq_lane_s16(vgetq_lane_s16((a), ((imm) >> 20) & 0xF), *res, 5); \
  *res = vsetq_lane_s16(vgetq_lane_s16((a), ((imm) >> 28) & 0xF), *res, 7); 

#define vshuff_s16_odd(a, imm, res) \
  *res = vsetq_lane_s16(vgetq_lane_s16((a), ((imm)) & 0xF), *res, 0); \
  *res = vsetq_lane_s16(vgetq_lane_s16((a), ((imm) >> 8) & 0xF), *res, 2); \
  *res = vsetq_lane_s16(vgetq_lane_s16((a), ((imm) >> 16) & 0xF), *res, 4); \
  *res = vsetq_lane_s16(vgetq_lane_s16((a), ((imm) >> 24) & 0xF), *res, 6); 

#define SIG_CANCEL_SIGNAL SIGUSR2
#define pthread_cancel(thread)  pthread_kill(thread, SIG_CANCEL_SIGNAL)
#define pthread_setaffinity_np(X, Y, Z)  sched_setaffinity(X, sizeof(Z), Z)
#define pthread_attr_setaffinity_np(X, Y, Z)   0
#define PTHREAD_GETAFFINITY(X, Y)  { \
    union { cpu_set_t c ; int32_t i; } cs; cs.i = 1 << sched_getcpu() ; Y = cs.c; s=0; }

#endif //__srslte_defines_h_

