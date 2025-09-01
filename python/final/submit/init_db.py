import sqlite3
import requests
import json

conn = sqlite3.connect('db/database.db')

with open('db/schema.sql') as f: 
    conn.executescript(f.read())

conn.execute("INSERT INTO crypto (code, crypto_name, ticker) VALUES (?, ?, ?)", 
            ('BTC', 'Bitcoin', 'BTC-USD') 
            )
conn.execute("INSERT INTO crypto (code, crypto_name, ticker) VALUES (?, ?, ?)", 
            ('ETH', 'Ethereum', 'ETH-USD') 
            )
conn.execute("INSERT INTO crypto (code, crypto_name, ticker) VALUES (?, ?, ?)", 
            ('BNB', 'Binance', 'BNB-USD') 
            )
conn.execute("INSERT INTO crypto (code, crypto_name, ticker) VALUES (?, ?, ?)", 
            ('SOL', 'Solana', 'SOL-USD') 
            )
conn.execute("INSERT INTO crypto (code, crypto_name, ticker) VALUES (?, ?, ?)", 
            ('DOGE', 'Dogecoin', 'DOGE-USD') 
            )
conn.execute("INSERT INTO crypto (code, crypto_name, ticker) VALUES (?, ?, ?)", 
            ('DOT', 'Polkadot', 'DOT-USD') 
            )
conn.execute("INSERT INTO crypto (code, crypto_name, ticker) VALUES (?, ?, ?)", 
            ('LTC', 'Litecoin', 'LTC-USD') 
            )

conn.commit()

conn.close()