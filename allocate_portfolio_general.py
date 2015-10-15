# -*- coding: utf-8 -*-
"""
Created on Wed Oct 14 12:35:21 2015

@author: jai
"""

# This script computes the number of shares of each asset necessary to achieve a 
# target portfolio allocation when adding additional funds:
# This script requires the user to input desired assets, target portfolio allocation, 
# current shares owned, and funds to be added to portfolio:

# PREP:

# Import needed modules:
import pandas as pd
import requests as rq
from lxml import html
from numpy import floor

# DEFINE TARGET PORTFOLIO ALLOCATION:

# Specify all desired assets in target portfolio:
# MANUAL INPUT REQUIRED:
# Example: assets = ['AAPL', 'GOOG']
assets = []
  
# Specify desired percentage of total portfolio for each asset in 'assets':
# Order of percentages should correspond to the order of assets provided in 'assets':
# Note: sum of 'target_percentages' should be 1:
# MANUAL INPUT REQUIRED:
# Example: target_percentages = [0.25, 0.75]
target_percentages = []
 
# CURRENT PORTFOLIO:
# Provide current portfolio in terms of number of shares:
# Order of shares should correspond to the order of assets provided in 'assets':
# MANUAL INPUT REQUIRED:
# Example: current_shares = [5, 10]
current_shares = []
  
# CURRENT PRICES:
# Obtain current prices of assets specified in 'CURRENT PORTFOLIO':
# Results are stored in the vector 'current_prices':
# This section uses web scraping, which I think is limited to some number of requests per day:

# Create empty (for now) 'current_prices' vector:
current_prices = []
  
# Scrape prices for assets in 'assets':
for i in assets:
    
    # Identify page with relevant asset price:
    # This script uses Yahoo Finance price quotes:
    page = rq.get('https://finance.yahoo.com/q?s=' + i)
    
    # Get HTML from 'page':
    page_html = html.fromstring(page.text)

    # Scrape price:
    price = page_html.xpath('//*[(@id = "yfs_l84_' + i.lower() + '")]/text()')   

    # Append 'price' to 'current_prices':
    current_prices.append(float(price[0]))
del(i)
  
# COMPUTE CURRENT PORTFOLIO VALUE:
  
# Create data frame with portfolio information:
portfolio = (pd.DataFrame(data = [assets, target_percentages, current_shares, current_prices]))
portfolio = portfolio.transpose()
portfolio.columns = ['assets', 'target_percentages', 'current_shares', 'current_prices']

# Compute equity for each asset:
portfolio['equity'] = portfolio.current_shares * portfolio.current_prices
  
# Compute portfolio current value:
current_value = sum(portfolio.equity)

# COMPUTE NEW ALLOCATION OF SHARES AFTER ADDING ADDITIONAL FUNDS:
    
# Specify amount to be added($):
# MANUAL INPUT REQUIRED:
# Example: to_add = 10000.00
to_add =
  
# Compute total dollar value of portfolio:
total_value = current_value + to_add
    
# Compute how much equity should be invested in each asset
# (in 'portfolio$assets') according to the target allocation:
portfolio['ideal_equity'] = portfolio.target_percentages * total_value

# Compute how many total shares should be purchased for each asset
# (in 'portfolio$assets') according to the target allocation:
# I found this difficult for some reason and so have a roundabout approach:
portfolio['ideal_shares'] = portfolio.ideal_equity / portfolio.current_prices
portfolio.ideal_shares = portfolio.ideal_shares.tolist()
portfolio.ideal_shares= floor(portfolio.ideal_shares)

# Compute how much equity, how many total shares, and how many additional shares 
# should be invested in each asset
# (in 'portfolio$assets') according to the target allocation:
portfolio['shares_to_buy'] = portfolio.ideal_shares - portfolio.current_shares
  
# Compute money that will be leftover after buying 'portfolio$shares_to_buy':
leftover = to_add - sum(portfolio.current_prices * portfolio.shares_to_buy)