# ExTxt2MarkovChain

Exercise in producing a [Markov Chain](https://en.wikipedia.org/wiki/Markov_chain) out of text.

## Notes

I noted some "toy" implementations which:
- start new process to keep the state.
- allow duplicate data.

I've tried to give it a quick stab while avoiding both.

## Examples

```sh
$ cat test.txt
A Markov chain or Markov process is a stochastic model describing a sequence of possible events in
which the probability of each event depends only on the state attained in the previous event. Informally, this
may be thought of as, "What happens next depends only on the state of affairs now." A countably infinite
sequence, in which the chain moves state at discrete time steps, gives a discrete-time Markov chain (DTMC).
$ iex
```

```elixir
iex> ExTxt2MarkovChain.generate("test.txt")
%ExTxt2MarkovChain{
  map: %{
    {"time", "markov"} => {1, 0.5},
    {"moves", "state"} => {1, 1.0},
    {"the", "previous"} => {1, 0.2},
    {"chain", "dtmc"} => {1, 0.3333333333333333},
    {"state", "attained"} => {1, 0.3333333333333333},
    {"a", "stochastic"} => {1, 0.2},
    {"the", "chain"} => {1, 0.2},
    {"stochastic", "model"} => {1, 1.0},
    {"countably", "infinite"} => {1, 1.0},
    {"a", "sequence"} => {1, 0.2},
    {"on", "the"} => {2, 1.0},
...
```

Or

```Elixir
iex> ExTxt2MarkovChain.new()
...> |> ExTxt2MarkovChain.update({"white", "cat"})
...> |> ExTxt2MarkovChain.update({"white", "cat"})
...> |> ExTxt2MarkovChain.update({"white", "dog"})
...> |> ExTxt2MarkovChain.update({"black", "cat"})
...> |> ExTxt2MarkovChain.calculate_probability()
%ExTxt2MarkovChain{
  map: %{
    {"black", "cat"} => {1, 1.0},
    {"white", "cat"} => {2, 0.6666666666666666},
    {"white", "dog"} => {1, 0.3333333333333333}
  }
}
```
