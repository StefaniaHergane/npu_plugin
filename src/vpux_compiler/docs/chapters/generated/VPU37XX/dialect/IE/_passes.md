<!-- Autogenerated by mlir-tblgen; don't manually edit -->
### `-delete-peraxis-quantization`: Delete PerAxis Quantize Dequantize for VPUX37XX
The pass is a part of `LowPrecision` pipeline.

It deletes per axis quantization which left after LPT.
Conversion is not mathimatically equal, but for now it gives small
    accuracy deviation
