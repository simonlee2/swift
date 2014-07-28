// RUN: %swift -emit-silgen %s | FileCheck %s

class Foo {
  var bar: Bar!
}

class Bar {
  var bas: C!
}

class C {}
class D: C {}

// CHECK-LABEL: sil @_TF27force_cast_chained_optional4testFCS_3FooCS_1D
// CHECK:         function_ref @_TFC27force_cast_chained_optional3Foog3barGSQCS_3Bar_
// CHECK:         function_ref @_TFSs41_doesImplicitlyUnwrappedOptionalHaveValueU__FRGSQQ__Bi1_
// CHECK:         cond_br {{%.*}}, [[SOME_BAR:bb[0-9]+]], [[NO_BAR:bb[0-9]+]]
// CHECK:       [[TRAP:bb[0-9]+]]:
// CHECK:         unreachable
// CHECK:       [[NO_BAR]]:
// CHECK:         br [[TRAP]]
// CHECK:       [[SOME_BAR]]:
// CHECK:         [[PAYLOAD_ADDR:%.*]] = unchecked_take_enum_data_addr {{%.*}} : $*ImplicitlyUnwrappedOptional<Bar>
// CHECK:         [[BAR:%.*]] = load [[PAYLOAD_ADDR]]
// CHECK:         [[GET_BAS:%.*]] = function_ref @_TFC27force_cast_chained_optional3Barg3basGSQCS_1C_
// CHECK:         apply [transparent] [[GET_BAS]]([[BAR]])
// CHECK:         function_ref @_TFSs36_getImplicitlyUnwrappedOptionalValueU__FGSQQ__Q_
// CHECK:         unconditional_checked_cast {{%.*}} : $C to $D
func test(x: Foo) -> D {
  return x.bar?.bas as D
}
