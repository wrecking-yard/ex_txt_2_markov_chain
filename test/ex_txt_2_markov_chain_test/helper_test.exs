defmodule ExTxt2MarkovChain.HelperTest do
  use ExUnit.Case

  alias ExTxt2MarkovChain.Helper

  test "Helper.group_by/2: base case" do
    input = %ExTxt2MarkovChain{
      map: %{
        {"eat", "sleep"} => {1, 1.0},
        {"run", "eat"} => {1, 0.5},
        {"run", "sleep"} => {1, 0.5},
        {"sit", "eat"} => {1, 0.5},
        {"sit", "run"} => {1, 0.5},
        {"sleep", "sit"} => {1, 1.0}
      }
    }

    expected_result = %{
      "eat" => [{"sleep", {1, 1.0}}],
      "run" => [{"eat", {1, 0.5}}, {"sleep", {1, 0.5}}],
      "sit" => [{"eat", {1, 0.5}}, {"run", {1, 0.5}}],
      "sleep" => [{"sit", {1, 1.0}}]
    }

    assert Helper.group_by(input, :start_state) === expected_result
  end
end
