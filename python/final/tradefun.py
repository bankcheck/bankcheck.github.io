import sqlite3
import pandas as pd
import numpy as np
import yfinance as yf

def getConn():
    conn = sqlite3.connect('db/database.db')
    conn.row_factory = sqlite3.Row
    return conn
    
class User:

    def __init__(self, userid):
        conn = getConn()

        row = conn.execute("SELECT token, avatar FROM user WHERE userid = ?",
                           (userid,)).fetchone()
        
        self.userid = userid
        self.token = row['token']
        self.avatar = row['avatar']

    def getPortfolio(self, market):  
        conn = getConn()

        rows = conn.execute("SELECT code, qty FROM portfolio " +
                            " WHERE userid = ? ", 
                            (self.userid,)).fetchall()
        
        df = pd.DataFrame(rows, columns=['code','qty'])

        df.set_index('code', inplace=True)
        conn.close()

        if not df.empty:
            df['name'] = market.info.loc[df.index,'crypto_name']
            df['price'] = market.info.loc[df.index,'price']
            df['val'] = df['qty'] * df['price']

        return df

    def getBalance(self, market):
        df = self.getPortfolio(market)

        if df.empty:
            bal = self.token
        else:
            bal = df['val'].sum() + self.token

        return bal
    
    def buy(self, code, qty, market):
        price = market.getQuote(code)

        if price == np.nan:
            return [False, "Cannot get latest quote"]
        
        fund = price * qty

        if self.token < fund:
            return [False, "Insufficiant fund.", "Last price: " + '${:,.2f}'.format(price), "Token needed: " + '${:,.2f}'.format(fund)]

        conn = getConn()

        try:
            conn.execute("INSERT INTO trans (userid, code, qty, price) VALUES (?, ?, ?, ?)", 
                         (self.userid, code, qty, price))
                                                
            row = conn.execute("SELECT qty FROM portfolio WHERE userid = ? AND code = ?",
                               (self.userid, code)).fetchone()
    
            #add to portfolio if no record 
            if row is None:
                conn.execute("INSERT INTO portfolio (userid, code, qty) VALUES (?, ?, ?)",
                             (self.userid, code, qty))
            
            #update qty if record exists
            else:
                conn.execute("UPDATE portfolio SET qty = qty + ? WHERE userid =? AND code = ?",
                             (qty, self.userid, code))

            #update token
            self.token -= fund
            conn.execute("UPDATE user SET token = ? WHERE userid =?", 
                         (self.token, self.userid))
           
        except Exception as e:
            message = type(e).__name__ + ": " + str(e)
            print(message)
            conn.rollback()
            return [False, message]
        
        finally:
            conn.commit()
            conn.close()

        return [True]
   
    def sell(self, code, qty, market):
        conn = getConn()

        row = conn.execute("SELECT qty FROM portfolio WHERE userid = ? AND code = ?",
                           (self.userid, code)).fetchone()
        
        if row is None:
            return [False, "Insufficiant quantity to sell", "No " + code + " in portfolio"]
        
        else: 
            oldQty = row[0]
        
        newQty = oldQty - qty

        if newQty < 0:
            return [False, "Insufficiant quantity to sell", "Only " + str(oldQty) + " " + code + " avaliable"]
        
        price = market.getQuote(code)

        if price == np.nan:
            return [False, "Cannot get latest quote"]

        try:
            #negative qty transaction means selling
            conn.execute("INSERT INTO trans (userid, code, qty, price) VALUES (?, ?, ?, ?)", 
                         (self.userid, code, qty*-1, price))
            
            #delete in portolio if no more qty after sold
            if newQty == 0:
                conn.execute("DELETE FROM portfolio WHERE userid=? AND code=?",
                             (self.userid, code))
            #update portolio
            else:
                conn.execute("UPDATE portfolio SET qty = ? WHERE userid =? AND code = ?",
                             (newQty, self.userid, code))

            #update token
            self.token += price * qty
            conn.execute("UPDATE user SET token = ? WHERE userid =?", 
                         (self.token, self.userid))
           
        except Exception as e:
            message = type(e).__name__ + ": " + str(e)
            print(message)
            conn.rollback()
            return [False, message]
        
        finally:
            conn.commit()
            conn.close()

        return [True]   
    
    def getTransactions(self):  
        conn = getConn()
        rows = conn.execute("SELECT createDt, code, " +
                            " CASE WHEN qty > 0 THEN 'Bought' " +
                            " ELSE 'Sold' END, " +
                            " ABS(qty), price, price * qty * -1 FROM trans " +
                            " WHERE userid = ? " + 
                            " ORDER BY createDt desc", 
                            (self.userid,)).fetchall()
        conn.close()
        return rows

class Market:
    def __init__(self):
        #get tradable assets
        conn = getConn()

        rows = conn.execute("SELECT code, crypto_name, ticker FROM crypto ").fetchall()
        
        self.info = pd.DataFrame(rows, columns=['code','crypto_name','ticker'])
        self.info.set_index('code', inplace=True)
        
        conn.close()

        self.update()
       
    def update(self):
        tickers = self.info['ticker'].to_list()

        try:    
            data = yf.Tickers(tickers)

            for key in data.tickers.keys():
                price = data.tickers.get(key).fast_info["last_price"]
                self.info.loc[self.info['ticker'] == key, 'price'] = price

        except Exception as e:
            print(type(e).__name__ + ": " + str(e))

    def getTicker(self, code):
        return self.info.loc[code, 'ticker']
    
    def getFullname(self, code):
        fullname =  self.info.loc[code, 'crypto_name'] + " (" + code + ")"
        return fullname
    
    def getQuote(self, code):
        ticker = self.getTicker(code)

        try:
            data = yf.Ticker(ticker)
            price = data.fast_info["last_price"]

        except Exception as e:
            print(type(e).__name__ + str(e))
            return np.nan

        else:
            #update dataframe whenever got quote for a single code
            self.info.loc[code, 'price'] = price
            return price
        
    #period: 1d, 5d, 1mo, 3mo, 6mo, 1y, 2y, 5y, 10y, ytd, max
    #interval: 1m, 2m, 5m, 15m, 30m, 60m, 90m, 1h, 1d, 5d, 1wk, 1mo, 3mo    
    def getHistory(self, code, period="5d", interval="1h"):
        ticker = self.getTicker(code)

        try:
            data = yf.Ticker(ticker)
            hist = data.history(period, interval)
            return hist

        except Exception as e:
            print(type(e).__name__ + str(e))
            return None