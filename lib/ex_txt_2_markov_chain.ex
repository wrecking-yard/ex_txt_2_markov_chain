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
            transition() =>
              nonempty_improper_list({transition_count(), transition_probability()}, {})
          }
        }

  @spec update(t(), transition()) :: t()
  def update(%__MODULE__{} = chain, {_state, _new_state} = transition) do
    get_and_update_in(
      chain.map[transition],
      fn
        nil ->
          {nil, {1, nil}}

        {count, _probability} = v ->
          {v, {count + 1, nil}}
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
    with key_prefixes <-
           Enum.map(
             Map.keys(chain.map),
             fn {prefix, _} ->
               prefix
             end
           )
           |> Enum.uniq(),
         transition_groups <-
           Enum.map(key_prefixes, fn p1 ->
             Enum.filter(Map.keys(chain.map), fn {p2, _} -> p2 === p1 end)
           end) do
      Enum.reduce(
        transition_groups,
        chain,
        fn group, acc ->
          key_count = Enum.reduce(group, 0, fn key, acc -> (chain.map[key] |> elem(0)) + acc end)

          Enum.reduce(
            group,
            acc,
            fn key, acc ->
              update_in(acc.map[key], fn {count, _probability} -> {count, count / key_count} end)
            end
          )
        end
      )
    end
  end

  @spec from_file(String.t()) :: t() | nil
  def from_file("") do
    nil
  end

  def from_file(file_path) when is_bitstring(file_path) do
    chain =
      Enum.reduce(
        Read.stream(file_path),
        %{chain: %__MODULE__{}, reminder: nil},
        fn line, acc ->
          {reminder, tokens} = Token.from_string(line, acc.reminder)

          chain =
            for [state, new_state] <- _generate_transitions(tokens), reduce: acc.chain do
              acc -> update(acc, {state, new_state})
            end

          %{chain: chain, reminder: reminder}
        end
      )

    update(chain.chain, {chain.reminder, nil})
    |> delete({nil, nil})
    |> calculate_probability()
  end

  defp _generate_transitions(states) when is_list(states) do
    Enum.chunk_every(states, 2, 1)
  end
end
