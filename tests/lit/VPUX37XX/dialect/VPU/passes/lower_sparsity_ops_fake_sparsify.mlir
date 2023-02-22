//
// Copyright (C) 2023 Intel Corporation
// SPDX-License-Identifier: Apache 2.0
//
// RUN: vpux-opt --split-input-file --init-compiler="vpu-arch=VPUX37XX" --lower-sparsity-ops="fake-sparsify=true" %s | FileCheck %s

#NHWC = affine_map<(d0, d1, d2, d3) -> (d0, d2, d3, d1)>
!defaultType = type tensor<1x16x16x16xf16, {order = #NHWC}>
!smType = type tensor<1x16x16x16xi1, {order = #NHWC}>
!sparseType = type !VPU.SparseTensor<data=!defaultType, sparsity_map=!smType>

func @LowerSparsifyOpF16(%arg0: !defaultType, %wt: tensor<16x1x1x4xsi32>, %weights: tensor<16x16x1x1xf16, {order = #NHWC}>) -> !defaultType {
    %0 = VPU.Sparsify(%arg0) : !defaultType -> !sparseType
    %1 = VPU.NCE.Convolution(%0, %weights, %wt) {
            pad = {bottom = 0 : i64, left = 0 : i64, right = 0 : i64, top = 0 : i64}, 
            rawFilterShape = [16, 16, 1, 1], 
            strides = [1, 1]
        } -> !defaultType 

    return %1 : !defaultType

    // CHECK:       [[SPARSITY_MAP:%.+]] = const.Declare tensor<1x16x16x16xi1, {order = #NHWC}> = dense<true> : tensor<1x16x16x16xi1, {order = #NHWC}>
    // CHECK:       [[VAL0:%.+]] = VPU.GroupSparseTensor(%arg0, [[SPARSITY_MAP]])
    // CHECK:       [[VAL1:%.+]] = VPU.NCE.Convolution([[VAL0]], %arg2, %arg1)
    // CHECK:       return [[VAL1]]
}

//
// -----
//

#NHWC = affine_map<(d0, d1, d2, d3) -> (d0, d2, d3, d1)>
!defaultType = type tensor<1x16x16x16x!quant.uniform<u8:f16, 2.0>, {order = #NHWC}>
!smType = type tensor<1x16x16x16xi1, {order = #NHWC}>
!sparseType = type !VPU.SparseTensor<data=!defaultType, sparsity_map=!smType>

func @LowerSparsifyOpUniformQuant(%arg0: !defaultType, %wt: tensor<16x1x1x4xsi32>, %weights: tensor<16x16x1x1xf16, {order = #NHWC}>) -> !defaultType {
    %0 = VPU.Sparsify(%arg0) : !defaultType -> !sparseType
    %1 = VPU.NCE.Convolution(%0, %weights, %wt) {
            pad = {bottom = 0 : i64, left = 0 : i64, right = 0 : i64, top = 0 : i64}, 
            rawFilterShape = [16, 16, 1, 1], 
            strides = [1, 1]
        } -> !defaultType 

    return %1 : !defaultType

    // CHECK:       [[SPARSITY_MAP:%.+]] = const.Declare tensor<1x16x16x16xi1, {order = #NHWC}> = dense<true> : tensor<1x16x16x16xi1, {order = #NHWC}>
    // CHECK:       [[VAL0:%.+]] = VPU.GroupSparseTensor(%arg0, [[SPARSITY_MAP]])
    // CHECK:       [[VAL1:%.+]] = VPU.NCE.Convolution([[VAL0]], %arg2, %arg1)
    // CHECK:       return [[VAL1]]
}

//
// -----
//

#NHWC = affine_map<(d0, d1, d2, d3) -> (d0, d2, d3, d1)>
!qElemType0 = type !quant.uniform<u8:f16:1, {1.0, 2.0, 3.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0}>
!defaultType = type tensor<1x16x16x16x!qElemType0, {order = #NHWC}>
!smType = type tensor<1x16x16x16xi1, {order = #NHWC}>
!sparseType = type !VPU.SparseTensor<data=!defaultType, sparsity_map=!smType>

func @LowerSparsifyOpPerAxisQuant(%arg0: !defaultType, %wt: tensor<16x1x1x4xsi32>, %weights: tensor<16x16x1x1xf16, {order = #NHWC}>) -> !defaultType {
    %0 = VPU.Sparsify(%arg0) : !defaultType -> !sparseType
    %1 = VPU.NCE.Convolution(%0, %weights, %wt) {
            pad = {bottom = 0 : i64, left = 0 : i64, right = 0 : i64, top = 0 : i64}, 
            rawFilterShape = [16, 16, 1, 1], 
            strides = [1, 1]
        } -> !defaultType 

    return %1 : !defaultType

    // CHECK:       [[SPARSITY_MAP:%.+]] = const.Declare tensor<1x16x16x16xi1, {order = #NHWC}> = dense<true> : tensor<1x16x16x16xi1, {order = #NHWC}>
    // CHECK:       [[VAL0:%.+]] = VPU.GroupSparseTensor(%arg0, [[SPARSITY_MAP]])
    // CHECK:       [[VAL1:%.+]] = VPU.NCE.Convolution([[VAL0]], %arg2, %arg1)
    // CHECK:       return [[VAL1]]
}