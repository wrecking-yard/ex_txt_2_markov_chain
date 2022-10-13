defmodule ExTxt2MarkovChain.Read do
  @spec stream(String.t(), [keyword()]) :: File.Stream.t()
  def(stream(file, opts \\ [encoding: :utf8]) when is_bitstring(file)) do
    File.stream!(file, opts, :line)
  end
end
