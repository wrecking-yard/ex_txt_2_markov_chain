defmodule ExTxt2MarkovChain.Token do
  @spec from_string(String.t(), String.t() | nil, function(), function()) ::
          {String.t() | nil, [String.t()]}
  def from_string(
        line,
        reminder \\ nil,
        tokenizer \\ fn data -> String.split(data, ~r/\s|[[:punct:]]/, trim: true) end,
        normalizer \\ &String.downcase/1
      )

  def from_string(line, reminder, tokenizer, normalizer)
      when is_bitstring(line) and is_bitstring(reminder) do
    from_string(Enum.join([reminder, " ", line]), nil, tokenizer, normalizer)
  end

  def from_string(line, reminder, tokenizer, normalizer)
      when is_bitstring(line) and is_nil(reminder) do
    parsed =
      line
      |> normalizer.()
      |> tokenizer.()

    case rem(length(parsed), 2) do
      0 -> {nil, parsed}
      1 -> List.pop_at(parsed, -1)
    end
  end
end
