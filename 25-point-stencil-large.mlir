builtin.module {
  func.func @_25_point_stencil_large(%a : !stencil.field<[-4,#x_dim_pad]x[-4,#y_dim_pad]x[-4,#z_dim_pad]xf32>, %b : !stencil.field<[-4,#x_dim_pad]x[-4,#y_dim_pad]x[-4,#z_dim_pad]xf32>) {
    %time_m = arith.constant 0 : index
    %time_M = arith.constant #iter_count : index
    %step = arith.constant 1 : index
    %fnp1, %fn = scf.for %time = %time_m to %time_M step %step iter_args(%fi = %a, %fip1 = %b) -> (
        !stencil.field<[-4,#x_dim_pad]x[-4,#y_dim_pad]x[-4,#z_dim_pad]xf32>,
        !stencil.field<[-4,#x_dim_pad]x[-4,#y_dim_pad]x[-4,#z_dim_pad]xf32>
    ) {
      %0 = "stencil.load"(%fi) : (!stencil.field<[-4,#x_dim_pad]x[-4,#y_dim_pad]x[-4,#z_dim_pad]xf32>) -> !stencil.temp<?x?x?xf32>
      %1 = "stencil.apply"(%0) <{"operandSegmentSizes" = array<i32: 1, 0>}> ({
      ^0(%2 : !stencil.temp<?x?x?xf32>):
        %3 = arith.constant 0.04 : f32

        %4 = "stencil.access"(%2) {"offset" = #stencil.index<[-1, 0, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %5 = "stencil.access"(%2) {"offset" = #stencil.index<[-2, 0, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %6 = "stencil.access"(%2) {"offset" = #stencil.index<[-3, 0, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %7 = "stencil.access"(%2) {"offset" = #stencil.index<[-4, 0, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %8 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 0, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %9 = "stencil.access"(%2) {"offset" = #stencil.index<[1, 0, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %10 = "stencil.access"(%2) {"offset" = #stencil.index<[2, 0, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %11 = "stencil.access"(%2) {"offset" = #stencil.index<[3, 0, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %12 = "stencil.access"(%2) {"offset" = #stencil.index<[4, 0, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %13 = "stencil.access"(%2) {"offset" = #stencil.index<[0,-1, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %14 = "stencil.access"(%2) {"offset" = #stencil.index<[0,-2, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %15 = "stencil.access"(%2) {"offset" = #stencil.index<[0,-3, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %16 = "stencil.access"(%2) {"offset" = #stencil.index<[0,-4, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %17 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 1, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %18 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 2, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %19 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 3, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %20 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 4, 0]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %21 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 0,-1]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %22 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 0,-2]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %23 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 0,-3]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %24 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 0,-4]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %25 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 0, 1]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %26 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 0, 2]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %27 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 0, 3]>} : (!stencil.temp<?x?x?xf32>) -> f32
        %28 = "stencil.access"(%2) {"offset" = #stencil.index<[0, 0, 4]>} : (!stencil.temp<?x?x?xf32>) -> f32

        %30 = arith.mulf %4  , %3 : f32
        %31 = arith.mulf %5  , %3 : f32
        %32 = arith.mulf %6  , %3 : f32
        %33 = arith.mulf %7  , %3 : f32
        %34 = arith.mulf %8  , %3 : f32
        %35 = arith.mulf %9  , %3 : f32
        %36 = arith.mulf %10 , %3 : f32
        %37 = arith.mulf %11 , %3 : f32
        %38 = arith.mulf %12 , %3 : f32
        %39 = arith.mulf %13 , %3 : f32
        %40 = arith.mulf %14 , %3 : f32
        %41 = arith.mulf %15 , %3 : f32
        %42 = arith.mulf %16 , %3 : f32
        %43 = arith.mulf %17 , %3 : f32
        %44 = arith.mulf %18 , %3 : f32
        %45 = arith.mulf %19 , %3 : f32
        %46 = arith.mulf %20 , %3 : f32
        %47 = arith.mulf %21 , %3 : f32
        %48 = arith.mulf %22 , %3 : f32
        %49 = arith.mulf %23 , %3 : f32
        %50 = arith.mulf %24 , %3 : f32
        %51 = arith.mulf %25 , %3 : f32
        %52 = arith.mulf %26 , %3 : f32
        %53 = arith.mulf %27 , %3 : f32
        %54 = arith.mulf %28 , %3 : f32

        %55 = arith.addf %30, %31 : f32
        %56 = arith.addf %55, %32 : f32
        %57 = arith.addf %56, %33 : f32
        %58 = arith.addf %57, %34 : f32
        %59 = arith.addf %58, %35 : f32
        %60 = arith.addf %59, %36 : f32
        %61 = arith.addf %60, %37 : f32
        %62 = arith.addf %61, %38 : f32
        %63 = arith.addf %62, %39 : f32
        %64 = arith.addf %63, %40 : f32
        %65 = arith.addf %64, %41 : f32
        %66 = arith.addf %65, %42 : f32
        %67 = arith.addf %66, %43 : f32
        %68 = arith.addf %67, %44 : f32
        %69 = arith.addf %68, %45 : f32
        %70 = arith.addf %69, %46 : f32
        %71 = arith.addf %70, %47 : f32
        %72 = arith.addf %71, %48 : f32
        %73 = arith.addf %72, %49 : f32
        %74 = arith.addf %73, %50 : f32
        %75 = arith.addf %74, %51 : f32
        %76 = arith.addf %75, %52 : f32
        %77 = arith.addf %76, %53 : f32
        %78 = arith.addf %77, %54 : f32

        "stencil.return"(%78) : (f32) -> ()
      }) : (!stencil.temp<?x?x?xf32>) -> !stencil.temp<?x?x?xf32>
      "stencil.store"(%1, %fip1) {"bounds" = #stencil.bounds<[0, 0, 0], [#x_dim, #y_dim, #z_dim]>} : (!stencil.temp<?x?x?xf32>, !stencil.field<[-4,#x_dim_pad]x[-4,#y_dim_pad]x[-4,#z_dim_pad]xf32>) -> ()
      scf.yield %fip1, %fi : !stencil.field<[-4,#x_dim_pad]x[-4,#y_dim_pad]x[-4,#z_dim_pad]xf32>, !stencil.field<[-4,#x_dim_pad]x[-4,#y_dim_pad]x[-4,#z_dim_pad]xf32>
    }
    func.return
  }
}
