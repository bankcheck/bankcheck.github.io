import pandas as pd
import numpy as np
import matplotlib
import mplfinance as mpf
import time
from flask import Flask, render_template,  request, flash, session, abort, redirect
from flask_session import Session
from flask_bcrypt import Bcrypt 
from apscheduler.schedulers.background import BackgroundScheduler
from tradefun import User, Market, getConn

app = Flask(__name__)

app.config['SECRET_KEY'] = 'your secret key'
#initialization for session
app.config["SESSION_PERMANENT"] = True
app.config["SESSION_TYPE"] = "filesystem"

Session(app)
#initialization for password hash
bcrypt = Bcrypt(app) 

#initialization for scheduler
scheduler = BackgroundScheduler()

#use non-interactive backend to avoid multi-thread problem
matplotlib.use('Agg')

#initialization for market object
market = Market()

def updateMarket():
    market.update()
    print('Market info updated @', time.ctime())  

scheduler.add_job(updateMarket, 'interval', minutes=2) 

scheduler.start()

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        conn = getConn()
        userid = request.form['userid']
        passwd = request.form['passwd']

        row = conn.execute("SELECT passwd FROM user WHERE userid = ?",
            (userid,)).fetchone()
        conn.close()
        
        try:
            if bcrypt.check_password_hash(row["passwd"], passwd):
                session["user"] = User(userid)
                return home()
            else:
                flash('Login failed')

        except Exception as e:
            print(type(e).__name__ + ": " + str(e))
            flash('Login failed')
    
    return render_template("index.html")

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        userid = request.form['userid']

        try:
            conn = getConn()
            exist = conn.execute("SELECT * FROM user WHERE userid = ?", 
                                (userid,)).fetchone()
            #add user
            if exist is None:
                passwd = request.form['passwd']
                avatar = request.form['avatar']
                hashed_password = bcrypt.generate_password_hash(passwd).decode('utf-8') 
                conn.execute("INSERT INTO user (userid, passwd, avatar) VALUES (?, ?, ?)",
                            (userid, hashed_password, avatar))
                conn.commit()

            #userid already exist
            else:
                raise Exception('That username is taken. Try another.')
            
        except Exception as e:
            print(type(e).__name__ + ": " + str(e))
            flash(str(e))

        else:
            #add user successful
            session["user"] = User(userid)
            return home()

        finally:
            conn.close()
    
    #Back to signup page if error or GET
    return render_template("signup.html")

@app.route('/home')
def home():
    try:
        user = session["user"]
    except Exception as e:
        print(type(e).__name__ + ": " + str(e))
        return abort(403)  
    
    portfolio = user.getPortfolio(market)

    return render_template("home.html", user=user, market=market, portfolio=portfolio )

@app.route('/trade', methods=['GET', 'POST'])
def trade():
    try:
        user = session["user"]
    except Exception as e:
        print(type(e).__name__ + ": " + str(e))
        return abort(403)  

    if request.method == 'POST':
        action = request.form['action']
        code = request.form['code'].strip().upper()
        qty = request.form['qty']

        if code not in market.info.index:
            flash(code + ' not avaliable')

        elif action == 'quote':
            price = market.getQuote(code)
            if price == np.nan:
                flash('Error: Cannot retrieve latest price')
            
            #get quote successful
            price = '${:,.2f}'.format(price)

            #return with price info
            return render_template("trade.html", user=user, market=market, code=code, price=price)

        elif action == 'buy':
            try:
                validate_qty = float(qty)

                if not validate_qty.is_integer() or validate_qty <= 0:
                    flash('Quantity must be a positive whole number')
                else:
                    retval = user.buy(code, validate_qty, market)

                    if not retval[0]:
                        for i in range(1, len(retval)):
                            flash("Error: " + retval[i])
                    else:
                        #back to portfolio if successful
                        return home()

            except Exception as e:
                flash(type(e).__name__ + ": " + str(e))
            
        elif action == 'sell':
            try:
                validate_qty = float(qty)

                if not validate_qty.is_integer() or validate_qty <= 0:
                    flash('Quantity must be a positive whole number')
                else:
                    retval = user.sell(code, validate_qty, market)

                    if not retval[0]:
                        for i in range(1, len(retval)):
                            flash("Error: " + retval[i])
                    else:
                        #back to portfolio if successful
                        return home()    

            except Exception as e:
                flash(type(e).__name__ + ": " + str(e))
            
        #if error, return to page with all user inputs
        return render_template("trade.html", user=user, market=market, code=code, qty=qty)

    else:
        return render_template("trade.html", user=user, market=market )
    
@app.route('/statement')
def statement():
    try:
        user = session["user"]
    except Exception as e:
        print(type(e).__name__ + ": " + str(e))
        return abort(403) 

    rows = user.getTransactions()
    return render_template("statement.html", user=user, market=market, rows=rows)    

@app.route('/ranking')
def ranking():
    try:
        user = session["user"]
    except Exception as e:
        print(type(e).__name__ + ": " + str(e))
        return abort(403)  

    conn = getConn()
    rows = conn.execute("SELECT userid, avatar FROM user ").fetchall()

    df = pd.DataFrame(rows, columns=['userid','avatar'])
    conn.close()

    for index, row in df.iterrows():
        df.loc[index, 'balance'] = User(row['userid']).getBalance(market)
    
    sorted_df = df.sort_values(by=['balance'], ascending=False).head()
    sorted_df.reset_index(drop=True, inplace = True)
    sorted_df['rank'] = sorted_df.index + 1
    sorted_df['rank'] = sorted_df['rank'].map(str)
    return render_template("ranking.html", user=user, market=market, sorted_df=sorted_df)    

@app.route('/info/<code>')
def post(code):
    try:
        user = session["user"]
    except Exception as e:
        print(type(e).__name__ + ": " + str(e))
        return abort(403)  

    if code.strip().upper() not in market.info.index:
        return render_template("404.html", user=user, market=market)   
        
    df = market.getHistory(code)
    fname = "img/chart/" + code + ".png"

    try:
        mpf.plot(df, type='candle', savefig='static/' + fname, style='yahoo')
        time.sleep(5)
        hist = df.sort_index(ascending=False)

    except Exception as e:
        print(type(e).__name__ + ": " + str(e))
        return render_template("404.html", user=user, market=market)   
    
    return render_template("info.html", user=user, market=market, code=code, hist=hist, fname=fname) 

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')