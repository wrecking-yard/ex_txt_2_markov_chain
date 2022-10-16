defmodule ExTxt2MarkovChain.Helper do
  @type start_state :: :start_state
  @spec group_by(ExTxt2MarkovChain.t(), start_state()) :: map()
  def group_by(%ExTxt2MarkovChain{} = chain, :start_state) do
    Enum.reduce(
      Map.keys(chain.map),
      %{},
      fn {start_state, _}, acc ->
        Map.put(
          acc,
          start_state,
          for(
            {^start_state, _} = {^start_state, new_state} <- Map.keys(chain.map),
            do: {new_state, Map.get(chain.map, {start_state, new_state})}
          )
        )
      end
    )
  end
end
