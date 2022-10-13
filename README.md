# ExTxt2MarkovChain

Exercise in converting text to [Markov Chain](https://en.wikipedia.org/wiki/Markov_chain)

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
map:%{
{"time","markov"}=>[1,0.027777777777777776],
{"the","previous"}=>[1,0.027777777777777776],
{"chain","dtmc"}=>[1,0.027777777777777776],
{"stochastic","model"}=>[1,0.027777777777777776],
{"countably","infinite"}=>[1,0.027777777777777776],
{"be","thought"}=>[1,0.027777777777777776],
{"of","as"}=>[1,0.027777777777777776],
{"a","markov"}=>[1,0.027777777777777776],
{"possible","events"}=>[1,0.027777777777777776],
{"event","depends"}=>[1,0.027777777777777776],
...
```

Or

```Elixir
iex> ExTxt2MarkovChain.new()
...> |> ExTxt2MarkovChain.update({"white", "cat"})
...> |> ExTxt2MarkovChain.update({"white", "cat"})
...> |> ExTxt2MarkovChain.update({"black", "cat"})
...> |> ExTxt2MarkovChain.calculate_probability()
%ExTxt2MarkovChain{
  map: %{
    {"black", "cat"} => [1, 0.3333333333333333],
    {"white", "cat"} => [2, 0.6666666666666666]
  }
}
```
