# Cryptosignal

Blockchain related project to get realtime arbitrage signal.

Blockchain technology allow a digital asset to be trully portable. It no longer tied to one central platform owner and depends on the institution to be integrated with others. This also allow a cryptoasset to be traded freely across multiple trading platform. 

## Cryptoasset exchange vs stock exchange
Crypto asset exchange in general have a simplified version or forex or stock trading platform. They have order book mechanism and matching engine based on price-time algorithm. 

Unlike Forex or stock trading, asset in crypto is very portable, allow us to move our asset from one crypto exchange to another in matter of minutes. 

## What is arbitrage

Arbitrage is the action of simultaneous buying and selling of securities, currency, or commodities in different markets or in derivative forms in order to take advantage of differing prices for the same asset.

With each crypto asset exchange commonly publish their API to the public, one can in theory constantly listen to their API to compare and calculate price difference in real time, find the lowest and highest to get potential arbitrage signal.

## Technical Aspect

There are several challenge to accomplish this.

#### How to connect to multiple cryptoexchange?

Eventhough each exchange publish and document their API, to implement each of it will take significant amount of time. Luckily there are several opensource library which wrap those API into one unified interface such as CCXT (https://github.com/ccxt/ccxt)

#### How to query and process at the same time or very low latency?

For this signal to be accurate and usable, the latency between processing price query to multiple exchange must be as minimum as possible. However, most of common programming language is not designed for concurrency, therefore if we want to get accurate arbitrage signal we must process query simultaneously using technology which allow concurrency such as (golang, erlang/elixir, or java in concurrent manner). The common popular language such as PHP, ruby, python is not well suited for this task without orchestrating a complicated solution.

Luckily we found an open source library, written in erlang for this kind of task called monitrage (https://github.com/virkillz/monitrage). The library meant to be used to power trading bot, but we will tweak to power our web application.

### How to calculate the signal?

As described in Monitrage README documentation, we don't simply compare the last price between the multiple exchanges because it will not provide information regarding buying and selling power between the two. Instead, we look into order book, and separate ask and bid list, find the best price of bid and ask from each exchanges, rank them and calculate whether there are pofitable combination.


### How we structure our application?

Monitrage library provide an example to turn the library into backend application which emmits websocket api. We can simply follow the instruction to build it, deploy in server and create website to fetch the data trough websocket. Since phoenix (popular web framework for elixir) have its own websocket implementation, we will use phoenix.js to consume the websocket.
