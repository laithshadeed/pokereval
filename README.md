# pokereval

[![Build Status](https://secure.travis-ci.org/laithshadeed/pokereval.svg?branch=master)](http://travis-ci.org/laithshadeed/pokereval)
[![Code Climate](https://codeclimate.com/github/laithshadeed/pokereval/badges/gpa.svg)](https://codeclimate.com/github/laithshadeed/pokereval)
[![Coverage Status](https://coveralls.io/repos/github/laithshadeed/pokereval/badge.svg?branch=master)](https://coveralls.io/github/laithshadeed/pokereval?branch=master)

Pocker evaluator heavily inspired by [@wojtekmach
Elixir's implementation](https://github.com/wojtekmach/poker_elixir) and [Cactus Kev's algorithm](http://suffe.cool/poker/evaluator.html)

## Usage

```
$ ./bin/pokereval '4D 4D 4D 7H 8D'
<hand [4D 4D 4D 7H 8D], 'Three Of A Kind'>
```

OR

```
$ docker run laithshadeed/pokereval:0.1 '4D 4D 4D 7H 8D'
<hand [4D 4D 4D 7H 8D], 'Three Of A Kind'>
```
---

To run tests

```
$ bundle
$ rake
```

## Links

- [Elixir's implementation](https://github.com/wojtekmach/poker_elixir)
- [List of poker hands Wiki](https://en.wikipedia.org/wiki/List_of_poker_hands)
- [Cactus Kev's Poker Hand Evaluator](http://suffe.cool/poker/evaluator.html)
- [Kev's poker table](http://suffe.cool/poker/7462.html)
- [Paul Senzee's faster implementation](https://web.archive.org/web/20180325123210/http://www.paulsenzee.com/2006/06/some-perfect-hash.html)
- [Perfect Hash Function Wiki](https://en.wikipedia.org/wiki/Perfect_hash_function)
- [Bob Jenkins' perfect hashing](http://burtleburtle.net/bob/hash/perfect.html)
