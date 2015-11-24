# H4H Bot

Can now 

# Run

The Telegram bot token must be available in the environment.
(See example below.)

```
export H4H_BOT_TOKEN=23456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11

```

# Build Instructions.

Can be compiled with GHC. Currently tested with GHC v7.10.2.

```
$ apt-get install ghc cabal-install
$ git clone git@github.com:house4hack/h4h-bot.git
$ cd h4h-bot
$ cabal sandbox init
$ cabal install --dependencies-only
$ cabal configure
$ cabal build
$ ./dist/build/h4h-bot/h4h-bot
```
