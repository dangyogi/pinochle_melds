# gunicorn.conf.py

chdir = '/home/pi/Servers/pinochle/pinochle_melds/server'
bind = '127.0.0.1:8080'
workers = 1
accesslog = '/var/log/pinochle/access.log'
errorlog = '/var/log/pinochle/error.log'
capture_output = True
