builtin.module {
  func.func @loop_kernel_small(%a : !stencil.field<[-1,#x_dim_pad]x[-1,#y_dim_pad]x[-1,#z_dim_pad]xf32>, %b : !stencil.field<[-1,#x_dim_pad]x[-1,#y_dim_pad]x[-1,#z_dim_pad]xf32>) {
    %time_m = arith.constant 0 : index
    %time_M = arith.constant #iter_count : index
    %step = arith.constant 1 : index
    %fnp1, %fn = scf.for %time = %time_m to %time_M step %step iter_args(%fi = %a, %fip1 = %b) -> (
        !stencil.field<[-1,#x_dim_pad]x[-1,#y_dim_pad]x[-1,#z_dim_pad]xf32>,
        !stencil.field<[-1,#x_dim_pad]x[-1,#y_dim_pad]x[-1,#z_dim_pad]xf32>
    ) {
      %0 = "stencil.load"(%fi) : (!stencil.field<[-1,#x_dim_pad]x[-1,#y_dim_pad]x[-1,#z_dim_pad]xf32>) -> !stencil.temp<?x?x?xf32>
      %1 = "stencil.apply"(%0) <{"operandSegmentSizes" = array<i32: 1, 0>}> ({
      ^0(%2 : !stencil.temp<?x?x?xf32>):
        %3 = arith.constant 1.666600e-01 : f32
        %4 = "stencil.access"(%2) {"offset" = #stencil.index<[1, 0, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %5 = "stencil.access"(%2) {"offset" = #stencil.index<[-1, 0, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %6 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 0, 1]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %7 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 0, -1]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %8 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 1, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %9 = "stencil.access"(%2) {"offset" = #stencil.index<[0, -1, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %10 = arith.addf %9, %8 : f32
        %11 = arith.addf %10, %7 : f32
        %12 = arith.addf %11, %6 : f32
        %13 = arith.addf %12, %5 : f32
        %14 = arith.addf %13, %4 : f32
        %15 = arith.mulf %14, %3 : f32
        "stencil.return"(%15) : (f32) -> ()
      }) : (!stencil.temp<?x?x?xf32>) -> !stencil.temp<?x?x?xf32>
      "stencil.store"(%1, %fip1) {"bounds" = #stencil.bounds<[0, 0, 0], [#x_dim, #y_dim, #z_dim]>} : (!stencil.temp<?x?x?xf32>, !stencil.field<[-1,#x_dim_pad]x[-1,#y_dim_pad]x[-1,#z_dim_pad]xf32>) -> ()
      scf.yield %fip1, %fi : !stencil.field<[-1,#x_dim_pad]x[-1,#y_dim_pad]x[-1,#z_dim_pad]xf32>, !stencil.field<[-1,#x_dim_pad]x[-1,#y_dim_pad]x[-1,#z_dim_pad]xf32>
    }
    func.return
  }
}
