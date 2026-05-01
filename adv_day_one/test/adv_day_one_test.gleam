import adv_day_one
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn turn_dial_left_test() {
  assert adv_day_one.turn_dial(50, 10, True) == 40
}

pub fn turn_dial_right_test() {
  assert adv_day_one.turn_dial(50, 10, False) == 60
}

pub fn turn_dial_wrap_around_left_test() {
  assert adv_day_one.turn_dial(5, 10, True) == 95
}

pub fn turn_dial_wrap_around_right_test() {
  assert adv_day_one.turn_dial(95, 10, False) == 5
}

pub fn process_input_left_test() {
  assert adv_day_one.process_input("L10") == #(True, 10)
}

pub fn process_input_right_test() {
  assert adv_day_one.process_input("R20") == #(False, 20)
}

pub fn process_inputs_test() {
  let dial_pointer = 50
  let inputs = ["L10", "L20", "L20"]
  assert adv_day_one.process_inputs(inputs, dial_pointer, 0) == 1
}
