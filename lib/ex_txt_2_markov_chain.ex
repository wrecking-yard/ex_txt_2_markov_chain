defmodule ExTxt2MarkovChain do
  alias ExTxt2MarkovChain.Token
  alias ExTxt2MarkovChain.Read

  defstruct map: %{}

  def new() do
    %__MODULE__{}
  end

  @type state :: String.t()
  @type transition :: {state(), state()}
  @type transition_probability :: nil | float()
  @type transition_count :: non_neg_integer()
  @type t :: %__MODULE__{
          map: %{
            transition() => nonempty_improper_list(transition_count(), transition_probability())
          }
        }

  @spec update(t(), transition()) :: t()
  def update(%__MODULE__{} = chain, {_state1, _state2} = transition) do
    get_and_update_in(
      chain.map[transition],
      fn
        nil ->
          {nil, [1, nil]}

        [count, _probability] = v ->
          {v, [count + 1, nil]}
      end
    )
    |> elem(1)
  end

  @spec delete(t(), transition()) :: t()
  def delete(%__MODULE__{} = chain, {_state1, _state2} = transition) do
    %__MODULE__{chain | map: Map.delete(chain.map, transition)}
  end

  @spec calculate_probability(t()) :: t()
  def calculate_probability(%__MODULE__{} = chain) do
    keys = Map.keys(chain.map)
    key_count = Map.values(chain.map) |> Enum.map(fn [c, _] -> c end) |> Enum.sum()

    Enum.reduce(
      keys,
      chain,
      fn k, acc ->
        update_in(acc.map[k], fn [count, _probability] -> [count, count / key_count] end)
      end
    )
  end

  @spec generate(String.t()) :: t() | nil
  def generate("") do
    nil
  end

  def generate(file_path) when is_bitstring(file_path) do
    chain =
      Enum.reduce(
        Read.stream(file_path),
        %{chain: %__MODULE__{}, reminder: nil},
        fn line, acc ->
          {reminder, tokens} = Token.from_string(line, acc.reminder)

          chain =
            for [state1, state2] <- Enum.chunk_every(tokens, 2, 2, :discard),
                reduce: acc.chain do
              acc -> update(acc, {state1, state2})
            end

          %{chain: chain, reminder: reminder}
        end
      )

    update(chain.chain, {chain.reminder, nil})
    |> delete({nil, nil})
    |> calculate_probability()
  end
end
