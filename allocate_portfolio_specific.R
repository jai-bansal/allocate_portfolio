# This script computes the number of shares of each asset necessary to achieve a target portfolio allocation when adding additional funds:
# This script is designed for my current portfolio; a different allocation and/or asset list will require changes:

# PREP:

  # Load needed packages:
  library(rvest)
  library(data.table)

# DEFINE TARGET PORTFOLIO ALLOCATION:

  # Specify all desired stocks in target portfolio:
  # MANUAL INPUT REQUIRED:
  assets = c('vti', 'vea', 'vwo', 'vnq', 'tip', 'tlt')
  
  # Specify desired percentage of total portfolio for each asset in 'assets':
  # Order of percentages should correspond to the order of assets provided in 'assets':
  # MANUAL INPUT REQUIRED:
  target_percentages = c(0.22, 0.14, 0.14, 0.2, 0.15, 0.15)
 
# CURRENT PORTFOLIO:
# Provide current portfolio in terms of number of shares:
# Order of shares should correspond to the order of assets provided in 'assets':
# MANUAL INPUT REQUIRED:
  
  current_shares = c(26, 48, 49, 31, 15, 14)
  
# CURRENT PRICES:
# Obtain current prices of assets specified in 'CURRENT PORTFOLIO':
# Order of prices should correspond to the order of assets provided in 'assets':
# MANUAL INPUT REQUIRED:
# This section uses web scraping, which I think is limited to some number of requests per day:
  
  # Obtain 'vti' current price:
  
    # Provide weblink for 'vti' price:
    vti_page = html('https://finance.yahoo.com/q?s=vti')
    
    # Scrape 'vti' price:
    vti_price = as.numeric(html_text(html_node(vti_page, '#yfs_l84_vti')))
    rm(vti_page)
  
  # Obtain 'vea' current price:
    
    # Provide weblink for 'vea' price:
    vea_page = html('https://finance.yahoo.com/q?s=vea')
    
    # Scrape 'vea' price:
    vea_price = as.numeric(html_text(html_node(vea_page, '#yfs_l84_vea')))
    rm(vea_page)
    
  # Obtain 'vwo' current price:
    
    # Provide weblink for 'vwo' price:
    vwo_page = html('https://finance.yahoo.com/q?s=vwo')
    
    # Scrape 'vwo' price:
    vwo_price = as.numeric(html_text(html_node(vwo_page, '#yfs_l84_vwo')))
    rm(vwo_page)
    
  # Obtain 'vnq' current price:
    
    # Provide weblink for 'vnq' price:
    vnq_page = html('https://finance.yahoo.com/q?s=vnq')
    
    # Scrape 'vnq' price:
    vnq_price = as.numeric(html_text(html_node(vnq_page, '#yfs_l84_vnq')))
    rm(vnq_page)

  # Obtain 'tip' current price:
  
    # Provide weblink for 'tip' price:
    tip_page = html('https://finance.yahoo.com/q?s=tip')
    
    # Scrape 'vea' price:
    tip_price = as.numeric(html_text(html_node(tip_page, '#yfs_l84_tip')))
    rm(tip_page)
  
  # Obtain 'tlt' current price:
    
     # Provide weblink for 'tip' price:
    tlt_page = html('https://finance.yahoo.com/q?s=tlt')
    
    # Scrape 'vea' price:
    tlt_price = as.numeric(html_text(html_node(tlt_page, '#yfs_l84_tlt')))
    rm(tlt_page)
    
  # Create 'current_prices' vector:
  current_prices = c(vti_price, vea_price, vwo_price, vnq_price, tip_price, tlt_price)
  rm(vti_price, vea_price, vwo_price, vnq_price, tip_price, tlt_price)
    
# COMPUTE CURRENT PORTFOLIO VALUE:
  
  # Create data table with portfolio information:
  portfolio = data.table(assets = assets, target_percentages = target_percentages, current_shares = current_shares, current_prices = current_prices)
  rm(assets, target_percentages, current_shares, current_prices)
  
  # Compute equity for each asset:
  portfolio$equity = portfolio$current_shares * portfolio$current_prices
  
  # Compute portfolio current value:
  current_value = sum(portfolio$equity)

# COMPUTE NEW ALLOCATION OF SHARES AFTER ADDING ADDITIONAL FUNDS:
    
  # Specify amount to be added($):
  # MANUAL INPUT REQUIRED:
  to_add = 1225.90
  
  # Compute total dollar value of portfolio:
  total_value = current_value + to_add
    
  # Compute how much equity, how many total shares, and how many additional shares should be invested in each asset
  # (in 'portfolio$assets') according to the target allocation:
  portfolio$ideal_equity = portfolio$target_percentages * total_value
  portfolio$ideal_shares = floor(portfolio$ideal_equity / portfolio$current_prices)
  portfolio$shares_to_buy = portfolio$ideal_shares - portfolio$current_shares
  
  # Compute money that will be leftover after buying 'portfolio$shares_to_buy':
  leftover = to_add - sum(portfolio$current_prices * portfolio$shares_to_buy)