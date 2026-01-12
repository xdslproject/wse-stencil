builtin.module {
  func.func @uvbke_medium(%arg0: !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>, %arg1: !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>, %arg2: !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>, %arg3: !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>, %arg4: !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>, %arg5: !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>) attributes {stencil.program} {

      %0 = stencil.cast %arg0 : !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32> -> !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>
      %1 = stencil.cast %arg1 : !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32> -> !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>
      %2 = stencil.cast %arg2 : !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32> -> !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>
      %3 = stencil.cast %arg3 : !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32> -> !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>
      %4 = stencil.cast %arg4 : !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32> -> !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>
      %5 = stencil.cast %arg5 : !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32> -> !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>
      %6 = stencil.load %0 : !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32> -> !stencil.temp<?x?x?xf32>
      %7 = stencil.load %1 : !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32> -> !stencil.temp<?x?x?xf32>
      %8 = stencil.load %2 : !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32> -> !stencil.temp<?x?x?xf32>
      %9 = stencil.load %3 : !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32> -> !stencil.temp<?x?x?xf32>
      %10 = stencil.apply (%arg6 = %6 : !stencil.temp<?x?x?xf32>, %arg7 = %7 : !stencil.temp<?x?x?xf32>, %arg8 = %8 : !stencil.temp<?x?x?xf32>, %arg9 = %9 : !stencil.temp<?x?x?xf32>) -> (!stencil.temp<?x?x?xf32>) {
        %cst = arith.constant 1.125000e+02 : f32
        %12 = stencil.access %arg7 [-1, 0, 0] : !stencil.temp<?x?x?xf32>
        %13 = stencil.access %arg7 [0, 0, 0] : !stencil.temp<?x?x?xf32>
        %14 = arith.addf %12, %13 : f32
        %15 = stencil.access %arg8 [0, 0, 0] : !stencil.temp<?x?x?xf32>
        %16 = arith.mulf %14, %15 : f32
        %17 = stencil.access %arg6 [0, -1, 0] : !stencil.temp<?x?x?xf32>
        %18 = stencil.access %arg6 [0, 0, 0] : !stencil.temp<?x?x?xf32>
        %19 = arith.addf %17, %18 : f32
        %20 = arith.subf %19, %16 : f32
        %21 = arith.mulf %cst, %20 : f32
        %22 = stencil.access %arg9 [0, 0, 0] : !stencil.temp<?x?x?xf32>
        %23 = arith.mulf %22, %21 : f32
        stencil.return %23 : f32
      }
      %11 = stencil.apply (%arg6 = %6 : !stencil.temp<?x?x?xf32>, %arg7 = %7 : !stencil.temp<?x?x?xf32>, %arg8 = %8 : !stencil.temp<?x?x?xf32>, %arg9 = %9 : !stencil.temp<?x?x?xf32>) -> (!stencil.temp<?x?x?xf32>) {
        %cst = arith.constant 1.125000e+02 : f32
        %12 = stencil.access %arg6 [0, -1, 0] : !stencil.temp<?x?x?xf32>
        %13 = stencil.access %arg6 [0, 0, 0] : !stencil.temp<?x?x?xf32>
        %14 = arith.addf %12, %13 : f32
        %15 = stencil.access %arg8 [0, 0, 0] : !stencil.temp<?x?x?xf32>
        %16 = arith.mulf %14, %15 : f32
        %17 = stencil.access %arg7 [-1, 0, 0] : !stencil.temp<?x?x?xf32>
        %18 = stencil.access %arg7 [0, 0, 0] : !stencil.temp<?x?x?xf32>
        %19 = arith.addf %17, %18 : f32
        %20 = arith.subf %19, %16 : f32
        %21 = arith.mulf %cst, %20 : f32
        %22 = stencil.access %arg9 [0, 0, 0] : !stencil.temp<?x?x?xf32>
        %23 = arith.mulf %22, %21 : f32
        stencil.return %23 : f32
      }
      stencil.store %10 to %4(<[0, 0, 0], [498, 498, 598]>) : !stencil.temp<?x?x?xf32> to !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>
      stencil.store %11 to %5(<[0, 0, 0], [498, 498, 598]>) : !stencil.temp<?x?x?xf32> to !stencil.field<[-4,502]x[-4,502]x[-4,602]xf32>
    func.return
  }
}
