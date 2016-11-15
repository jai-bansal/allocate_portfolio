#### Synopsis:
This project provides scripts (in R and Python) to compute the shares needed to achieve your target allocation.

#### Motivation:
I wrote this project to quickly compute how many shares I need to buy when adding funds to my investment portfolio.

#### Running Scripts:
The R and Python scripts are in the 'R' and 'Python' branches respectively.

The scripts CANNOT be run out of the box. User input is required at 4 places:
'assets':                 specifying assets in target portfolio
'target_percentages':     specifying desired percentages of assets in 'assets'
'current_shares':         specifying shares currently owned
'to_add':                 specifying how much money is being added to the portfolio

After running the script, the value of your portfolio (before adding funds) is stored in 'current_value'. The shares you need to buy (depending on your target allocation and funds you are adding) are in 'portfolio$shares_to_buy'. Finally, money that will be leftover (assuming only integer numbers of shares can be purchased) is stored in 'leftover'.

The 'current_percentage' column shows what the percentage accounted for by each security in the current portfolio.
The 'ideal_percentage' column shows what percentage will be accounted for by each security in the ideal portfolio.

#### License:
GNU General Public License
