# This script computes the number of shares of each asset necessary to achieve 
# a target portfolio allocation when adding additional funds:
# This script requires the user to input desired assets, target portfolio allocation, 
# current shares owned, and funds to be added to portfolio:

# PREP:

  # Load needed packages:
  library(quantmod)
  library(data.table)

# DEFINE TARGET PORTFOLIO ALLOCATION:

  # Specify all desired assets in target portfolio:
  # MANUAL INPUT REQUIRED:
  # Example: assets = c('AAPL', 'GOOG')
  assets = c()
  
  # Specify desired percentage of total portfolio for each asset in 'assets':
  # Order of percentages should correspond to the order of assets provided in 'assets':
  # Note: sum of 'target_percentages' should be 1:
  # MANUAL INPUT REQUIRED:
  # Example: target_percentages = c(0.25, 0.75)
  target_percentages = c()
 
# CURRENT PORTFOLIO:
# Provide current portfolio in terms of number of shares:
# Order of shares should correspond to the order of assets provided in 'assets':
# MANUAL INPUT REQUIRED:
# Example: current_shares = c(5, 10)
current_shares = c()
  
# CURRENT PRICES:
# Obtain current prices of assets specified in 'CURRENT PORTFOLIO':
# Results are stored in the vector 'current_prices':

  # Create empty (for now) 'current_prices' vector:
  current_prices = c()
  
  # Get prices for assets in 'assets':
  for (i in assets)
    {
  
      # Get last price for 'i' using 'quantmod' package.
      price = getQuote(tolower(i))$Last
      
      # Add 'price' to 'current_prices'.
      current_prices = c(current_prices, price)

  }
  rm(i, price)
  
# COMPUTE CURRENT PORTFOLIO VALUE:
  
  # Create data table with portfolio information:
  portfolio = data.table(assets = assets, target_percentages = target_percentages, 
                         current_shares = current_shares, current_prices = current_prices)
  rm(assets, target_percentages, current_shares, current_prices)
  
  # Compute equity for each asset:
  portfolio$equity = portfolio$current_shares * portfolio$current_prices
  
  # Compute portfolio current value:
  current_value = sum(portfolio$equity)

# COMPUTE NEW ALLOCATION OF SHARES AFTER ADDING ADDITIONAL FUNDS:
    
  # Specify amount to be added($):
  # MANUAL INPUT REQUIRED:
  # Example: to_add = 10000.00
  to_add = 
  
  # Compute total dollar value of portfolio:
  total_value = current_value + to_add
    
  # Compute how much equity, how many total shares, and how many additional shares should be invested in each asset
  # (in 'portfolio$assets') according to the target allocation:
  portfolio$ideal_equity = portfolio$target_percentages * total_value
  portfolio$ideal_shares = floor(portfolio$ideal_equity / portfolio$current_prices)
  portfolio$shares_to_buy = portfolio$ideal_shares - portfolio$current_shares
  
  # Compute money that will be leftover after buying 'portfolio$shares_to_buy':
  leftover = to_add - sum(portfolio$current_prices * portfolio$shares_to_buy)