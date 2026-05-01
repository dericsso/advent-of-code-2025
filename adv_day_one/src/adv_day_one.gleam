import file_streams/file_stream.{type FileStream}
import file_streams/file_stream_error.{type FileStreamError}
import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

const min_dial_value = 0

const input_file_name = "input.txt"

const max_dial_value = 99

pub fn main() -> Nil {
  let initial_dial_pointer = 50

  let input_result = read_input_file()
  let times_reached_zero = case input_result {
    Ok(inputs) -> {
      process_inputs(inputs, initial_dial_pointer, 0)
    }
    Error(err) -> {
      io.print_error(err)
      0
    }
  }
  echo times_reached_zero
  Nil
}

pub fn turn_dial(pointer: Int, turn_amount: Int, left_direction: Bool) -> Int {
  result.unwrap(
    case left_direction {
      True -> int.modulo(pointer - turn_amount, max_dial_value + 1)
      False -> int.modulo(pointer + turn_amount, max_dial_value + 1)
    },
    0,
  )
}

/// Process list of inputs and returns the times the dial reached 0
pub fn process_inputs(inputs: List(String), dial_pointer: Int, acc: Int) -> Int {
  case inputs {
    [] -> acc
    [input, ..inputs] -> {
      let #(is_left, turn_amount) = process_input(input)
      let new_dial_pointer = turn_dial(dial_pointer, turn_amount, is_left)
      case new_dial_pointer {
        0 -> process_inputs(inputs, new_dial_pointer, acc + 1)
        _ -> process_inputs(inputs, new_dial_pointer, acc)
      }
    }
  }
}

pub fn process_input(input: String) -> #(Bool, Int) {
  case string.pop_grapheme(input) {
    Ok(#(first, rest)) -> {
      let is_left = first == "L"
      let turn_amount_result = int.base_parse(rest, 10) |> result.unwrap(0)
      #(is_left, turn_amount_result)
    }
    Error(_) -> {
      io.print_error("Error processing input")
      #(False, 0)
    }
  }
}

fn read_input_file() -> Result(List(String), String) {
  use stream <- result.try(
    file_stream.open_read(input_file_name)
    |> result.replace_error("Error opening file, file might not exist"),
  )
  let lines = read_lines(stream, [])
  case file_stream.close(stream) {
    Ok(_) -> Ok(lines)
    Error(_) -> Error("Error closing file")
  }
}

fn read_lines(stream: FileStream, acc: List(String)) -> List(String) {
  case file_stream.read_line(stream) {
    Ok(line) ->
      read_lines(stream, [string.replace(line, each: "\n", with: ""), ..acc])
    Error(file_stream_error.Eof) -> list.reverse(acc)
    Error(_) -> {
      io.print_error("Error reading line from file")
      []
    }
  }
}
