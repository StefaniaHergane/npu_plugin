<!-- Autogenerated by mlir-tblgen; don't manually edit -->
### `-adapt-shapes-for-scale-shift`: Adjusts 2-d and 3-d `IE.Add` and `IE.Multiply` for further conversion to `IE.ScaleShift`
Converts these subgraphs:
```
    Input tensor<NxM> => IE.Add : tensor<NxM>, tensor<1xM> -> tensor<NxM>
    Input tensor<NxM> => IE.Multiply : tensor<NxM>, tensor<1xM> -> tensor<NxM>
    Input tensor<1xNxM> => IE.Add : tensor<1xNxM>, tensor<1x1xM> -> tensor<1xNxM>
    Input tensor<1xNxM> => IE.Multiply : tensor<1xNxM>, tensor<1x1xM> -> tensor<1xNxM>
```
Into the following subgraphs respectively:
```
    Input tensor<NxM> => IE.Add : tensor<1xMxNx1>, tensor<1xMx1x1> => tensor<NxM>
    Input tensor<NxM> => IE.Multiply : tensor<1xMxNx1>, tensor<1xMx1x1> => tensor<NxM>
    Input tensor<1xNxM> => IE.Add : tensor<1xMxNx1>, tensor<1xMx1x1> => tensor<1xNxM>
    Input tensor<1xNxM> => IE.Multiply : tensor<1xMxNx1>, tensor<1xMx1x1> => tensor<1xNxM>
```
The following shape transformations will be applied for 2-d case:
```
    Input NxM => Reshape 1xNxMx1 => Transpose 1xMxNx1 => Add => Transpose 1xNxMx1 => Reshape NxM
```
For 3-d case:
```
    Input 1xNxM => Reshape 1xNxMx1 => Transpose 1xMxNx1 => Add => Transpose 1xNxMx1 => Reshape 1xNxM
```
It is also possible to apply reshape to get `IE.Add : tensor<NxMx1x1>, tensor<1xMx1x1>`.
However, such approach may lead to a big cluster of NCE tasks after `UnrollBatch` pass.
The measurements show that transposition is more effective for this pass.
### `-adjust-input-shape-for-eltwise`: Reshape the activation inputs of eltwise ops to make the inputs' channel aligned without `IE.Expand`
Insert ShapeCast Ops to the inputs of eltwise ops when the input channels require alignment.
Insert ShapeCast Ops to the outputs before the next non-eltwise op.
### `-adjust-layouts`: Adjust required layouts for all layers
The pass is a part of `IECommon` pipeline.

This pass adds the required layouts instead of the default one
depending on the layer specification from underlying Dialect.
### `-adjust-software-ops-precision`: Adjust precision of software ops to satisfy kernel implementation
The pass is a part of `AdjustPrecision` pipeline.

Some kernel implementations only support specific precisions. To satisfy this requirement,
such ops are surrounded by conversion layers.
### `-align-scales`: Align FQ ranges around Concat layers.
This pass aligns FQ ranges around Concat ops and inserts Clamp ops to keep the valuse in the original ranges.

Original subgraph:
Conv1                 ARG
  |                    |
FQ1(range1)     FQ2(range2)
              |
            Concat
              |
            Conv2

New subgraph:
Conv1                                               ARG
  |                                                  |
FQ(newRange)                                        FQ(newRange)
  |                                                  |
Clamp(low and hight from original FQ)               Clamp(low and hight from original FQ)
                                            |
                                          Concat
                                            |
                                          Conv2
### `-broadcast-input-for-add`: Broadcast input for Add op
This pass broadcast input for AddOp when the input1's shape isn't equal to input2's shape which cannot convert to ScaleShift.
### `-convert-assign-read-value`: Convert assign to returns and read value to inputs
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces `Assign` operations with main function returns and
`ReadValue` operations with main function inputs.
### `-convert-avg-pool-to-dw-conv`: Convert AvgPool op to GroupConvolution op
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces suitable `AvgPool` operations with `GroupConvolution` operation.
### `-convert-batched-conv-to-1n`: Convert Convolution with batched input to new one with batch equal to 1
This pass inserts Transpose and Reshape to convert batched input to new one with batch equal to 1

Original operation:
    Activation: 4x16x1x1 ->
                            Conv -> 4x5x1x1
    Weights:    5x16x1x1 ->

New subgraph:
    Activation:4x16x1x1     Weights:5x16x1x1
        |                       |
    Transpose:16x4x1x1          |
        |                       |
    Reshape:1x16x4x1            |
        |                       |
                Conv:1x5x4x1
                    |
              Reshape:5x4x1x1
                    |
             Transpose:4x5x1x1
### `-convert-bilinear-to-strided-concat-and-conv`: Convert bilinear interpolate op to strided concat, MaxPool and some depthwise convolution Ops
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces `Bilinear Interpolate` operations with `Concat` operations with strides, MaxPool and some `depthwise` convolutions.
### `-convert-broadcast-to-tile`: Convert Broadcast operation to Tile operation
This pass replaces `Broadcast` operation with `Tile` operation.
### `-convert-conv1d-to-conv2d`: Convert Convolution1D and GroupConvolution1D to its 2D variance
The pass is a part of `AdjustForVPU` pipeline.

Extends input, filter and output tensors with height = 1.
[N, C, W] -> [N, C, 1, W]
strides:    {2} -> strides:    {1, 2}
pads_begin: {2} -> pads_begin: {0, 2}
pads_end:   {2} -> pads_end:   {0, 2}
dilations:  {2} -> dilations:  {1, 2}
### `-convert-deconv-to-conv`: Convert Deconvolution 2D to Convolution 2D
The pass is a part of `AdjustForVPU` pipeline.

Replaces deconvolution by upsampling and convolution
### `-convert-depthToSpace`: Convert DepthToSpace layer to {reshape -> transpose -> reshape} subgraph
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces all `DepthToSpace` operations with {reshape -> transpose -> reshape} subgraph.
### `-convert-extract-image-patches`: Converts subgraphs around ExtractImagePatches into some more optimal for VPU ones when the necessary conditions are met
Converts these subgraphs:
```
    IE.ReduceSum -> IE.ExtractImagePatches -> IE.Transpose -> IE.ReduceSum
    IE.ReduceSum -> IE.ExtractImagePatches -> IE.ReduceSum
    IE.ExtractImagePatches -> IE.Transpose -> IE.AffineReshape
    IE.ExtractImagePatches -> IE.Transpose
    IE.ExtractImagePatches
```
Into the following subgraphs respectively:
```
    IE.ReduceSum -> IE.Unsqueeze
    IE.ReduceSum -> IE.Unsqueeze
    N x IE.Slice -> IE.Concat
    N x IE.Slice -> IE.Concat -> IE.AffineReshape
    IE.Transpose
```
### `-convert-fc-to-conv`: Convert FullyConnected op to Convolution operation
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces all `FullyConnected` operations with `Convolution` operation.
It inserts extra `Reshape` operations to satisfy `Convolution` specification.
### `-convert-gather-to-slice`: Convert Gather operation to Slice operation
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces legal `Gather` operations with `Slice` operations.
### `-convert-matmul-to-conv`: Convert MatMul with 2d 'weights' to convolution
This pass replaces 2d `Matmul` operations with `Convolution` .
### `-convert-nearest-to-strided-concat`: Convert nearest interpolate op to strided concat ops
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces `Nearest Interpolate` operations with `Concat` operations with strides.
### `-convert-pad-to-concat`: Convert Pad Ops to Concat with Constant
The pass is a part of `AdjustForVPU` pipeline.

After FusePadOps pass, there are Pad Ops can not be fused.
Replace `IE::PadOp` with `IE::ConcatOp` and `Const::DeclareOp`
Only `IE::PadMode::CONSTANT` case is supported.
### `-convert-paddings-to-floor-mode`: Convert Convolution and Pooling layers paddings to FLOOR rouding mode
The pass is a part of `AdjustForVPU` pipeline.

This pass updates padding attributes for Convolution and Pooling layers.
It switches layer rounding mode to FLOOR and updates paddings to satisfy output shape.
### `-convert-power-to-mult`: Convert power to multiply operation
The pass converts power with single constant exponent value to multiplication.
### `-convert-precision-to-fp16`: Convert tensors precision from FP32 to FP16
The pass is a part of `AdjustPrecision` pipeline.

This pass replaces all FP32 tensors with FP16.
It updates both function bodies as well as Function signatures.
### `-convert-precision-to-i32`: Convert tensors precision from I64 to I32
The pass is a part of `AdjustPrecision` pipeline.
This pass replaces all I64 tensors with I32.
It updates both function bodies as well as Function signatures.
### `-convert-quantize-ops-to-nce-ops`: Converts per-tensor Quantize/Dequantize to eltwise And mixed-precision operation
The pass is a part of `LowPrecision` pipeline.

Converts per-tensor Quantize/Dequantize to eltwise And mixed-precision operation
where input2 is input1 to perform type conversion on DPU instead of UPA.
### `-convert-reduce-to-pooling`: Convert reduce to pooling ops
The pass is to convert reduce operations (mean, max, sum, min) into pooling.
### `-convert-reorder-to-permute-quantize`: Converts IE.Reorder to DPU permute
Converts IE.Reorder with float16 input and float16 output to DPU permute.
### `-convert-scale-shift-depthwise`: Convert Scale-Shift operation to Depthwise Convolution
The pass is a part of `HardwareMode` pipeline.

Convert Scale-Shift operation to Depthwise convolution.
### `-convert-shape-to-4d`: Convert tensors shapes to 4D
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces ND tensor with 4D analogues for layers, which has such limitations on VPUIP level.
Also this pass replaces ND network inputs and outputs with 4D analogues to overcome runtime limitations.
### `-convert-shuffle-channels`: Convert ShuffleChannels to Reshape->Transpose->Reshape
The pass is a part of `AdjustForVPU` pipeline.
Converts ShuffleChannels to Reshape->Transpose->Reshape.
### `-convert-spaceToDepth`: Convert SpaceToDepth layer to {reshape -> transpose -> reshape} pattern
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces all `SpaceToDepth` operations with {reshape -> transpose -> reshape} pattern.
### `-convert-squareddiff-to-subpower`: Convert SquaredDifference operation to Subtract and Power
This pass converts SquaredDifference operation to its equivalent (x-y)^2
### `-convert-subtract-to-add`: Convert Subtract operation to Add with either Negative or DW Conv operations
This pass replaces `Subtract` operation with `Add` with `Negative` operations on VPUX30XX or `Add` with `DW Conv` operations on VPUX37XX.
### `-convert-tile-to-per-axis-tiles`: Convert tile op by multiple axes to multiple PerAxisTile operations
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces all `Tile` op with a set of `PerAxisTile` operations.
### `-convert-to-mem-permute`: Convert Reorder and Transpose ops to MemPermute operation
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces all `Reorder` and `Transpose` operations with `MemPermute` operation.
### `-convert-to-mixed-precision`: Convert DPU task without fake quantize behind to mixed-precision operation
The pass is a part of `LowPrecision` pipeline.
Converts DPU task to mixed-precision operation where there is no quantize operation for the output of a DPU task
### `-convert-to-scale-shift`: Convert Add and Multiply operations to ScaleShift operations
This pass replaces suitable `Add` and `Multiply` operations with `ScaleShift` operations.
### `-convert-upsampling-to-strided-concat`: Convert upsampling op to strided concat op
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces `Upsampling` operations with `Concat` operations with strides and a zero filled const.
### `-convert-weights-to-u8`: Shift data from a signed range to an unsigned one
The pass is a part of `LowPrecision` pipeline.

Pass detects quantized convolution and shifts weights data from a signed range to an unsigned one
### `-delete-peraxis-quantization`: Delete PerAxis Quantize Dequantize for VPUX37XX
The pass is a part of `LowPrecision` pipeline.

It deletes per axis quantization which left after LPT.
Conversion is not mathimatically equal, but for now it gives small
    accuracy deviation
### `-dequantize-const`: Dequantize constant tensors
The pass is a part of `LowPrecision` pipeline.

It performs constant folding for `Constant -> quant.dcast` case.
The pass is used as a fallback to FP16 computations for the cases, where quantized types where not used by layers.
### `-expand-activation-channels`: Allign input tensors shape of DPU operation with hardware requirements
The pass is a part of `buildHardwareModePipeline` pipeline.

This pass processes operations, which can be compile as a DPU tasks and
    expands channels number to number divisible by 16 in case they doesn't satisfy hardware requirements
### `-expand-activation-width`: Align input tensors shape of DPU operation with hardware requirements
This pass processes operations, which can be compiled as DPU tasks and
expands output width to the next number divisible by 16 when they don't
meet hardware requirements.
Applicable only for operations with NHWC input and NCHW output.
For instance, consider convolution with 16x20x23 input, 16x18x21 output and 3x3 kernel.
21 is not divisible by 16, so the output width must be expanded to 32: 16x18x32.
In order to comply to the operation traits, input width must be expanded to 16x20x34.

Supported operations:
* IE.Convolution
* IE.GroupConvolution
* IE.MaxPool
* IE.AvgPool
* IE.Add
### `-force-host-precision-layout-conversion`: Move pre-/post- processing operations to host side
This pass detects the following pre-/post- processing operations and excludes them from device IR:

* Convert
* Reorder

The pre-/post- processing will be performed on host by the plugin.
### `-force-host-quantization`: Support input quantization on host side for VPUX compiler
Support input quantization on host side for VPUX compiler.

Note: current implementation will not allow us to use this feature in CiD case.
### `-fuse-convert-with-quantize`: Fuse Convert with Quantize into QuantCast operation
Pass detects pattern Convert(i8/ui8 -> FP16) -> Quantize(FP16 -> !quant.uniform<...>)
and fuses it into single QuantCast(i8/ui8 -> !quant.uniform<...>) operation.
### `-fuse-pad-ops`: Fuse PadOp with CONSTANT model
The pass is a part of `AdjustForVPU` pipeline.

PadOp with CONSTANT model, pad value is 0 and the padding is needed in H and W dimensions only.
Merge [Pad] -> [Conv] into [Conv].
Merge [Pad] -> [GroupConv] into [GroupConv].
Merge [Pad] -> [MaxPool] into [MaxPool].
### `-fuse-permute-quantize`: Converts Quantize-MemPermute combination in 1 common operation
Converts Quantize-MemPermute combination in 1 common operation.
### `-fuse-permute-quantize-expand`: Converts Quantize-MemPermute-Expand combination in 1 common operation
Converts Quantize-MemPermute-Expand combination in 1 common operation.
### `-fuse-post-ops`: Fuse activation functions with tasks that support post-processing
The pass is a part of `AdjustForVPU` pipeline.

Fuse activation functions (e.g. ReLU, leaky ReLU) with tasks that support post-processing
depending on the compilation mode
### `-fuse-quantized-ops`: Update quantize/dequantize ops
The pass is a part of `LowPrecision` pipeline.

Pass detects pattern quant.dcast -> op -> quant.qcast and converts it into single quantized Op
### `-fuse-reorders`: Fuses reorder to previous NCE task as ODU permutation
Converts these subgraphs:
```
    Input [NHWC] -> IE.Convolution [NHWC] -> IE.Reorder [NCHW]
    Input [NHWC] -> IE.GroupConvolution [NHWC] -> IE.Reorder [NCHW]
    Input [NHWC] -> IE.MaxPool [NHWC] -> IE.Reorder [NCHW]
    Input [NHWC] -> IE.AvgPool [NHWC] -> IE.Reorder [NCHW]
    Input [NHWC] -> IE.Add [NHWC] -> IE.Reorder [NCHW]
```
Into the following subgraphs respectively:
```
    Input [NHWC] -> IE.Convolution [NCHW]
    Input [NHWC] -> IE.GroupConvolution [NCHW]
    Input [NHWC] -> IE.MaxPool [NCHW]
    Input [NHWC] -> IE.AvgPool [NCHW]
    Input [NHWC] -> IE.Add [NCHW]
```
### `-handle-asymmetric-strides`: Handle operations with asymmetric strides
The pass is a part of `AdjustForVPU` pipeline.

This pass splits operations so that they are able to be infered with symmetric strides
    on dpu because of hardware limitation.
### `-handle-exclude-pad-for-avg-pool`: Handle exclude-pad attribute for AvgPool operations
This pass introduces exclude pad atribute handling for AvgPool operations, that have pad = stride = 1,
by splitting operation in multiple AvgPool operations in order to handle this particular case.
### `-handle-large-kernels`: Handle large kernels ops
The pass is a part of `AdjustForVPU` pipeline.

This pass replaces average pooling layers that have kernels bigger than supported by hardware (11x11),
with equivalent average pooling (approx equiv in case of prime kernel i.e. 13x13).
For FP16-INT8: support to split into two average pooling.
For FP16 / FP32: support multiple splits (converting to more than two average pooling ops) as there is no loss
                 of accuracy from the varying min/max ranges of the intermediate average pooling ops.
### `-handle-large-strides`: Handle operations with large strides
This pass splits operations with strides larger than supported on hardware.
### `-insert-maxpool-to-concat-activation`: Insert Maxpool op between Concat and Activation ops
Pass converts Concat->Activation to Concat->Maxpool->Activation.
### `-layer-reorder-concat-pass`: Inserts Reorder operation between Transpose and Concat
The pass is a part of `HardwareMode` pipeline.

It inserts `Reorder` operation between layers `Transpose`, `AffineReshape` and `Concat` operation when possible.
This transormation reduces the number of `MemPermute` operations in resulting graph.
### `-legalize-dilated-conv`: Handle dilated convolutions
The pass is a part of `buildHardwareModePipeline` pipeline.

This pass expands filter of dilated convolution so that they are able to be infered
    on dpu because of hardware limitation.
### `-legalize-nd-mem-permute`: Legalize MemPermute operation with input rank > 4
This pass tries to legalize MemPermute operations by merging dims that are adjacent before and after the permutation.
Applied only for VPUX.37XX because SW Kernel Tiling is limited to 4D.
### `-matmul-inputs-to-2d`: Convert MatMul inputs to 2d
This pass converts `MatMul` inputs to 2d.

For example, `MatMul` input with 4x1x64 geometry will be split to four inputs with 1x64 dimensions.
Resulting inputs with filters go to `MatMul` operations and the outputs are concatenated.
### `-merge-fake-quant`: Merge back to FakeQuantize
The pass is a part of `LowPrecision` pipeline.

It merges pair `quant.qcast -> quant.dcast` into single `IE.FakeQuantize`.
The pass is used as a fallback to FP16 computations for the cases, where quantized types where not used by layers.
### `-move-permute-post-eltwise`: Move the input Permute ops post Eltwise to reduce the number of Permute ops
The layout does not matter for eltwise ops as long as the input and output layouts are the same.
move the permute ops from the inputs of the eltwise to the output to reduce the number of permute ops.
### `-optimize-concat-slice`: Bypass concat if slice is the subtensor of one of concat inputs
For the pattern ConcatOp->SliceOp, if SliceOp input is the subtensor of one of ConcatOp input,
Bypass ConcatOp and ConcatOp would be removed if it has only one user.
### `-optimize-reorders`: Optimize extra Reorder operations
The pass is a part of `IECommon` pipeline.

This pass tries to optimize out Reorder operations for common cases
by propagating them from inputs to outputs and merging into layers.
### `-optimize-slice-expand`: Optimize patterns Slice->Expand and Slice->Implicit operations ->Expand
The pass is a part of `buildHardwareModePipeline` pipeline.

Optimize patterns Slice->Expand and Slice->Implicit operations ->Expand in order to avoid extra DMAs
### `-optimize-unaligned-qdq-seq`: Swaps AffineReshape->FakeQuantize sequence if channels become unaligned after AffineReshape
Pass swaps order of AffineReshape->FakeQuantize sequence if channels become unaligned after AffineReshape
Otherwise additionals ops are introduce in order to align channels which impacts performance.
### `-per-axis-fq-concat`: Supports Concat operation with per-axis FQ inputs
The pass is a part of `HardwareMode` pipeline.

It creates `FakeQuantize` operation, which combines per-channel quantization from `Concat` inputs,
and places it after the `Concat` operation. For example:
The following `Concat`:
```
    FQ 1x256x128x128 -> Concat <- FQ 1x48x128x128
                          |
                        GroupConv 1x304x128x128
```
will be transformed into:
```
    FQ 1x256x128x128 -> Concat <- FQ 1x48x128x128
                          |
                         FQ 1x304x128x128
                          |
                        GroupConv 1x304x128x128
```
### `-propagate-affine-reshape`: Moves AffineReshape operation down
Supported cases:
* Move through Transpose
* Move through Expand
* Move through Concat // TODO: #-58713
    Before:
        AffineReshape ->
        AffineReshape -> Concat
        AffineReshape ->
    After:
        Concat -> AffineReshape
### `-propagate-expand`: Propagate Expand operation in order to fuse it with other layers
Propagate Expand through Eltwise Add in case layers before might be fused with Expand
in following cases:
1. PermuteQuntize might be fused with Expand in FusePermuteQuantizeExpand pass
2. DepthToSpace is used with padded channels' descriptor

### `-propagate-fq-through-concat`: Propagate FakeQuantize operation through Concat
`ConvertPadToConcat` adds a `Concat` operation which does not propagate `FakeQuantize` operation.

1. Check if such `Concat` operation has one and only one quantized input
2. Fetch quantization parameters
3. Apply them to every single `Concat` input and output
### `-propagate-quantize-dequantize`: Propagate Quantize/Dequantize through agnostic operations
The pass is a part of LowPrecision pipeline.

Quantize/Dequantize are propagated through operations
### `-propagate-reorder-to-nce`: Propagate reorder back to NCE task through act shave layers
Converts these subgraphs:
```
    Input [NHWC] -> IE.Convolution [NHWC] -> Act shave layer -> IE.Reorder [NCHW]
    Input [NHWC] -> IE.GroupConvolution [NHWC] -> Act shave layer -> IE.Reorder [NCHW]
    Input [NHWC] -> IE.MaxPool [NHWC] -> Act shave layer -> IE.Reorder [NCHW]
    Input [NHWC] -> IE.AvgPool [NHWC] -> Act shave layer -> IE.Reorder [NCHW]
    Input [NHWC] -> IE.Add [NHWC] -> Act shave layer -> IE.Reorder [NCHW]
```
Into the following subgraphs respectively:
```
    Input [NHWC] -> IE.Convolution [NHWC] -> IE.Reorder [NCHW] -> Act shave layer [NCHW]
    Input [NHWC] -> IE.GroupConvolution [NHWC] -> IE.Reorder [NCHW] -> Act shave layer [NCHW]
    Input [NHWC] -> IE.MaxPool [NHWC] -> IE.Reorder [NCHW] -> Act shave layer [NCHW]
    Input [NHWC] -> IE.AvgPool [NHWC] -> IE.Reorder [NCHW] -> Act shave layer [NCHW]
    Input [NHWC] -> IE.Add [NHWC] -> IE.Reorder [NCHW] -> Act shave layer [NCHW]
```
### `-remove-quantdequant-seq`: Removes quantize->dequantize ops sequence
The optional pass in the `LowPrecision` pipeline.

Pass detects pattern quantize -> dequantize and removes it
### `-replace-inf-fq`: Replace infinite range FQ to Clamp
Replaces FakeQuantize ops with infinite ranges to Clamp in order to avoid compilation fail.
### `-resolve-scatter-update-by-transpose`: Resovle ScatterUpdate operation by Transpose Operation
The pass is a part of `AdjustForVPU` pipeline.
Only axis == 0 is supported in SWkernel.
The pass replaces ScatterUpdate(axis!=0) with `IE::Transpose-IE::ScatterUpdate(axis=0)-IE::Transpose` pipeline.

### `-resolve-strided-slice`: Decouple strided slice to slice + reshape
The pass is a part of `AdjustForVPU` pipeline.
It replaces IE::StridedSlice with non zero masks to a simpler IE::StridedSlice with zero masks + IE::Reshape
It replaces IE::StridedSlice with dense<1> strides strides with a simple IE::Slice operation
### `-split-conv-with-multiple-fq`: Splits Convolution for multiple FakeQuantize
The pass is a part of `HardwareMode` pipeline.

It splits `Convolution` operation with multiple consumers with `FakeQuantize` operations,
into multiple `Convolution` operations, one for each consumer. This transformation is needed to be
able to quantize convolution and fuse bias and post-processing operations.
### `-split-fake-quant`: Splits FakeQuantize
The pass is a part of `LowPrecision` pipeline.

It splits `FakeQuantize` operations to `quant.qcast -> quant.dcast` pair.
### `-swap-concat-with-eltwise`: Swaps Concat operation with elementwise -> FQ patterns
The pass is a part of `HardwareMode` pipeline.

It swaps `Concat` operation with elementwise -> FQ subgraph when possible. For example:
* `PReLU` -> per-tensor `FakeQuantize` subgraph is eligible for such swap.

This transormation allows to fuse `FakeQuantize` to NCE operations.
### `-swap-convert-with-transpose-reshape`: Swaps Transpose operation with Convert
The pass is a part of `HardwareMode` pipeline.

It swaps `Transpose` and 'Reshape' operations with Convert operation when possible.
This transormation reduces the number of `MemPermute` operations in resulting graph.
### `-swap-fake-quant-reshape`: Swap FakeQuantize with Reshape when required to void redundant expand and permute ops
The pass is a part of `LowPrecision` pipeline.

It matches pattern non-channel-aligned op -> optional Reshapes -> FQ -> Reshapes -> channel-aligned op
Move the FQ right before the channel-aligned op to avoid redundant expand and permute ops.
### `-swap-maxpool-with-act`: Swaps the MaxPool and activation
This pass is needed for VPUX37XX only since HW MaxPool does not support post-op operations.
Operations are swapped only if there is an operation before MaxPool that supports post-ops.
### `-swap-mvn-with-transpose`: Swaps MVN operation with parent Transpose
The pass is a part of `HardwareMode` pipeline.

It swaps `MVN` with Transpose operation when possible.
This transormation reduces the number of `MemPermute` operations in resulting graph.
### `-swap-operations`: Swap operations implemented ElemTypeInfoOpInterface interface with bias and activation
In order to fuse the bias and activation functions into a main operation,
intermediate operations will be moved after the fusable operation. For example:
  `Conv -> Reshape -> bias` will be converted to `Conv -> bias -> Reshape`
  `Conv -> Transpose -> ReLU` will be converted to `Conv -> ReLU -> Transpose
Only operations that implement `IE_ElemTypeInfoOpInterface` are moved.
Currently, operations are moved only through bias (Add), ReLU, Sigmoid, Tanh.

### `-swap-pad-layer`: Swap pattern Pad -> Transpose to Transpose -> Pad
In order to fuse Pad layer to Convolution swap Pad with operations between it and Convolution.
For now only case Pad -> Transpose is supported

### `-swap-quant-cast-and-clamp`: Swap QuantizeCast and Clamp operations
After AlignScales pass we have an additional Clamp layers in IR.
Therefore, we may get such subgraph:
ARG -> FQ -> Clamp -> Concat

Then after SplitFakeQuant and PropagateQuantizeDequantize we have:
ARG -> Q -> Clamp -> D -> Concat

Then after ConvertQuantizeOpsToNceOps we have:
ARG -> Add -> QuantizeCast -> Clamp -> QuantizeCast -> Add -> Concat

In order to fuse Clamp into eltwise Add we need to move QuantizeCast after Clamp.
### `-swap-transpose-concat`: Swap Transpose and Concat operations
Pass converts pattern from
Transpose ->
Transpose -> Concat
Transpose ->

to
Concat -> Transpose
### `-swap-transpose-with-fq`: Swaps Transpose operation with FakeQuantize
The pass is a part of `HardwareMode` pipeline.

It swaps `Transpose` operation with per-tensor `FakeQuantize` operation when possible.
This transormation reduces the number of `MemPermute` operations in resulting graph.
### `-transpose-to-permute-cast`: Converts Transpose operation to PermuteCast with Reorder
It is possible to replace a `Transpose` operation with a combination of `PermuteCast` and `Reorder`.
To compute the permutation cast, which is required for the source tensor, one must inverse the
affine map from the original `Transpose` operation. For example, consider the following transposition:
`1x16x32x64 -> 1x64x16x32`, its affine map is: `(d0, d1, d2, d3) -> (d0, d3, d1, d2)`.
The inverse will be:
```
    d0, d3, d1, d2   ->  d0, d1, d2, d3
    aN, aC, aH, aW   ->  aN, aH, aW, aC
```
Which gives permutation cast into NHWC.
In order to maintain the layout in data flow, `Reorder` must always rearrange `PermuteCast` result into the
order of original `Transpose` operation.
### `-uniquify-branches`: Eliminates redundant operations from multiple branches
Convert this subgraph:
         -> Slice -> Layer -> Consumer
Producer -> Slice -> Layer -> Consumer
         -> Slice -> Layer -> Consumer

into this:
                  -> Slice -> Consumer
Producer -> Layer -> Slice -> Consumer
                  -> Slice -> Consumer

in case Slice and Layer transform different axes.

Now at the place of "Layer" supported Reorder and Expand operations
### `-uniquify-ops`: Remove duplicating operations with a common producer Value
The pass is a part of `AdjustForVPU` pipeline.

This pass merges operations that are identical to each other, combining consumers.
### `-unroll-batch`: Split FullyConnected inputs with multiple rows
This pass splits `FullyConnected` inputs by rows.

For example, `FullyConnected` input with 2x64 geometry will be split by two inputs with 1x64 dimensions.
Resulting vector rows go to corresponding `FullyConnected` operations and the outputs are concatenated.
### `-upstream-slice`: Optimization by upstreaming slice operations
Optimizes scenarios of IE::StridedSlice and IE::SliceOp without neighboring operations.
Moves the slice operations upwards through the graph, reducing both compute and memory usage.
In some cases the slice operation may be safely removed from the graph, if the action of upstreaming it
    only adapts the operations constants.
### `-use-user-layout`: Use user layouts for entry point function prototype
The pass is a part of `IECommon` pipeline.

This pass updates the CNNNetwork entry point function prototype
and uses user-provided layouts for its operands and results.
The pass inserts Reorder operations from/to topology layout.
### `-use-user-precision`: Use user precisions for entry point function prototype
The pass is a part of `IECommon` pipeline.

This pass updates the CNNNetwork entry point function prototype and use user-provided precisions for its operands and results.
The pass inserts Convert operations from/to topology precisions.