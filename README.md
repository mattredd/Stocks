#  Stocks
**Stocks** is an app to find the most relevant financial information for you. You can quickly glance at your most popular stocks, see the latest updates from the world markets or view the most up to date position of your stock portfolio.

This app is built entirely with SwiftUI and using the new async/await concurrency feature. The app also uses the Local Authentication framework so that uses can identify themselves when trying to access thier portfolio. And as the portfolio data is stored within the Keychain, this ensures that the user's personal information is kept secure. 

**Stocks** requires iOS 15.2 or above to run

## Overview

### Watchlist
<img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-04-19 at 17 54 18" src="https://user-images.githubusercontent.com/5818573/164129708-06024b44-b0e0-4d6e-833d-c3a6411cf13d.png"> <img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-04-19 at 17 55 34" src="https://user-images.githubusercontent.com/5818573/164129720-69865b68-ea50-445d-9f61-676889398aac.png"> <img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-04-19 at 18 00 07" src="https://user-images.githubusercontent.com/5818573/164129728-6feb31ef-8571-467b-acbb-dcf10d0b9398.png">
<img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-04-19 at 17 54 35" src="https://user-images.githubusercontent.com/5818573/164129733-a43e4159-9df4-4e3b-9ab5-2c282905b01f.png">

The watchlist is a list of the financial securities you wish to view on a regular basis. You can add stocks, markets, currencies, and futures to the watchlist. You can click on an individual financial security to view more details about it.

## Markets
<img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-04-14 at 17 05 40" src="https://user-images.githubusercontent.com/5818573/163441186-80e8e7c1-c751-40d9-a6ba-10178a175857.png"> <img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-04-14 at 18 01 00" src="https://user-images.githubusercontent.com/5818573/163441205-28c79288-7126-486d-b94e-b82fb507088a.png">

The markets screen is a curated list of stock markets from around the world. You can see the price of each market and the change in price. The cell of the list places a heavy emphasis on the daily change of the market using a line chart.

## Commodities
<img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-04-24 at 01 53 17" src="https://user-images.githubusercontent.com/5818573/164951080-4ef701d7-4db5-4dc8-89a9-f3698566caf3.png">

The commodities list is a curated list of commodities.

## Portfolio
<img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-04-14 at 18 01 42" src="https://user-images.githubusercontent.com/5818573/163441278-63256608-1636-4a9f-9f86-6bcceca5ce7b.png"> <img width="231" alt="Simulator Screen Shot - iPhone 13 - 2022-04-14 at 18 01 45" src="https://user-images.githubusercontent.com/5818573/163441712-4b4e4daa-1f86-4f7e-8de9-5eca441fd150.png">

The portfolio view is a way to monitor your financial portfolio. You can add your stocks to the portfolio and enter the price you paid for the stock and the quantity. To edit or delete a stock, simple swipe from the right. Each entry in your portfolio will reflect the profit or loss using the most current price and it will use the stock's local currency. You can also see a summary of your portfolio which will show you the total profit or loss of your portfolio. The currency used in the summary will be taken from the locale of the device you are using. As this screen contains personal financial information there is a requirement for you to authenticate yourself using the device's biometric security or a passcode.


## Widget

The app uses WidgetKit so that users can place a widget on their home screen so that they can quickly glance at their data. The widget will show the first two stocks in the users watchlist.
