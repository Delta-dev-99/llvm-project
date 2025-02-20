; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=pwr8 -mtriple=powerpc64le-unknown-linux-gnu < %s \
; RUN:   -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names | FileCheck --check-prefix=CHECK-LE \
; RUN:   -implicit-check-not vmrg -implicit-check-not=vperm %s
; RUN: llc -verify-machineinstrs -mcpu=pwr8 -mtriple=powerpc64-unknown-linux-gnu < %s \
; RUN:   -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names | FileCheck \
; RUN:   -implicit-check-not vmrg -implicit-check-not=vperm %s
; RUN: llc -verify-machineinstrs -mcpu=pwr8 -mtriple=powerpc64-ibm-aix-xcoff < %s \
; RUN:   -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names | FileCheck \
; RUN:   -implicit-check-not vmrg -implicit-check-not=vperm %s
; RUN: llc -verify-machineinstrs -mcpu=pwr8 -mtriple=powerpc-ibm-aix-xcoff < %s \
; RUN:   -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names | FileCheck \
; RUN:   --check-prefix=CHECK-AIX-32 -implicit-check-not vmrg \
; RUN:   -implicit-check-not=vperm %s

define <16 x i8> @test(i32* %s, i32* %t) {
; CHECK-LE-LABEL: test:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    lfiwzx f0, 0, r3
; CHECK-LE-NEXT:    xxspltw v2, vs0, 1
; CHECK-LE-NEXT:    blr
;
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfiwzx f0, 0, r3
; CHECK-NEXT:    xxspltw v2, vs0, 1
; CHECK-NEXT:    blr
;
; CHECK-AIX-32-LABEL: test:
; CHECK-AIX-32:       # %bb.0: # %entry
; CHECK-AIX-32-NEXT:    lwz r3, 0(r3)
; CHECK-AIX-32-NEXT:    mtfprwz f0, r3
; CHECK-AIX-32-NEXT:    xxspltw v2, vs0, 1
; CHECK-AIX-32-NEXT:    blr

entry:
  %0 = bitcast i32* %s to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 4
  %2 = shufflevector <4 x i8> %1, <4 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
  ret <16 x i8> %2
}
