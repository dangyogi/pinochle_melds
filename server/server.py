# server.py

'''There are two cookies:

NAME (max_age=1 year)
CONTEXT (session)
'''

import os
import time
from collections import defaultdict, Counter

import bottle
from bottle import (
    get, post, request, response, redirect, run, template, static_file,
    HTTPError
)

#from . import classes
#import classes


SECRET = 'asdlfj;l3kj4lkjsorzughypaob8usoaru7b0SDFWERSXBBBBBu1'
CODE_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(CODE_DIR)
STATIC_DIR = os.path.join(PROJECT_DIR, "static")
VIEWS_DIR = os.path.join(PROJECT_DIR, "views")
HOUR = 60*60
YEAR = 365*24*HOUR


Next_session_id = 1

Sessions = {}  # {session_id: {key: value}}


def get_session():
    r'''Returns dict for this user's session information.

    This is currently simply maintained in RAM; so if the server crashes, it's
    all gone!  This also will not work for multiple server processes...

    New sessions are initialized with a single "session_id" key containing
    this user's session_id.  (Which is probably not that interesting)...
    '''
    global Next_session_id

    session_id = request.get_cookie('session_id', secret=SECRET)
    if session_id is None:
        session_id = Next_session_id
        Next_session_id += 1
        response.set_cookie('session_id', session_id, max_age=8*HOUR,
                            secret=SECRET)
    if session_id not in Sessions:
        Sessions[session_id] = dict(session_id=session_id,
                                    suits=Suit_names,
                                    suit_spans=Suit_spans,
                                   )
    return Sessions[session_id]


Arounds = dict(ace=(0, 10, 100, 200), king=(0, 8, 80, 160),
               queen=(0, 6, 60, 120), jack=(0, 4, 40, 80))
Runs = (0, 15, 150, 300)
Marriages = (0, 2, 4, 60, 120)  # The 2 and 4 are doubled for trump
Pinochles = (0, 4, 30, 60, 120)

Denominations = ('ace', 'ten', 'king', 'queen', 'jack')

Suit_names = ("hearts", "spades", "diamonds", "clubs")
Suit_spans = (
    '<span style="color:red; font-size: 130%">&#x2665</span>',
    '<span style="font-size: 130%">&#x2660</span>',
    '<span style="color:red; font-size: 130%">&#x2666</span>',
    '<span style="font-size: 130%">&#x2663</span>',
)

Suits = frozenset(Suit_names)


@get('/favicon.ico')
def favicon():
    raise HTTPError(404, 'Not Found');


@get('/')
def home():
    print("home called")
    clear_cards(get_session())
    redirect('/count_cards')


def clear_cards(session):
    for den in Denominations:
        for suit in Suits:
            key = f"{den}_{suit}"
            session[key] = 0
    session['trump'] = "hearts"


@post("/count_cards")
def count_cards():
    print("count_cards called")
    session = get_session()
    cards = {}                      # {(den, suit): count}
    by_den = defaultdict(Counter)   # {den: {suit: count}}
    by_suit = defaultdict(Counter)  # {suit: {den: count}}
    for suit in Suits:
        for den in Denominations:
            key = f"{den}_{suit}"
            count = int(request.forms.get(key))
            cards[den, suit] = session[key] = count
            by_den[den][suit] += count
            by_suit[suit][den] += count
            print(key, count, sep='=', end=',')
        print()

    # {trump_suit: {meld: (number, meld_points)}}
    melds = defaultdict(lambda: defaultdict(lambda: (0, 0)))

    def add_melds(meld, number, points, *suits):
        print("add_melds", meld, number, points, suits)
        for suit in suits:
            old_number, old_points = melds[suit][meld]
            melds[suit][meld] = old_number + number, old_points + points

    meld_points = Counter()  # {trump_suit: meld_points}
    def add_points(points, *suits):
        for suit in suits:
            meld_points[suit] += points

    # Check for Arounds (e.g., "4 Aces")
    for den in ("ace", "king", "queen", "jack"):
        suit_counts = by_den[den]
        if len(suit_counts) == 4:
            count = min(suit_counts.values())
            if count:
                if count >= 15:
                    add_melds(f"15 Cards", 1, 300, *Suits)
                    add_points(300, *Suits)
                else:
                    points = Arounds[den][count]
                    add_melds(f"4 {den.title()}s", count, points, *Suits)
                    add_points(points, *Suits)

    # Check for Runs
    for suit in Suits:
        den_counts = by_suit[suit]
        if len(den_counts) == 5:
            count = min(den_counts.values())
            if count:
                points = Runs[count]
                add_melds("Run", count, points, suit)
                add_points(points, suit)

    # Check for Marriages
    king_suits = by_den['king']
    queen_suits = by_den['queen']
    for suit in Suits:
        count = min(king_suits[suit], queen_suits[suit])
        if count > 2:
            # Same for Trump and non-Trump.  Not invalidated in Trump by Runs.
            points = Marriages[count]
            add_melds("Marriages", count, points, *Suits)
            add_points(points, *Suits)
        elif count:
            # Double in Trump.  Invalidated by Runs.
            other_suits = Suits.difference([suit])
            points = Marriages[count]
            add_melds("Marriages", count, points, *other_suits)
            add_points(points, *other_suits)
            count -= melds[suit]['Run'][0]
            if count:
                points = 2 * Marriages[count]
                add_melds("Marriages", count, points, suit)
                add_points(points, suit)

    # Check for Pinochles
    count = min(by_den['queen']['spades'], by_den['jack']['diamonds'])
    if count:
        points = Pinochles[count]
        add_melds("Pinochles", count, points, *Suits)
        add_points(points, *Suits)

    session['melds'] = melds
    for suit in Suits:
        print(suit, melds[suit])
        print(suit, meld_points[suit])
    session['meld_points'] = meld_points
    redirect("/make_bid")


@post("/make_bid")
def make_bid():
    print("make_bid called")
    session = get_session()
    session['partners_meld_bid'] = int(request.forms.partners_meld_bid)
    session['trump'] = request.forms.trump
    redirect('/show_bids')


@post("/meld")
def meld():
    print("meld called")
    session = get_session()
    session['who_won_bid'] = request.forms.who_won_bid
    session['trump'] = request.forms.trump
    redirect("/show_meld")


@post('/show_meld')
def show_meld():
    print("show_meld called")
    session = get_session()
    session['trick_points'] = int(request.forms.trick_points)
    print("show_meld got", session['trick_points'])
    csv_path = os.path.join(PROJECT_DIR, 'trick_hints.csv')
    csv_exists = os.path.exists(csv_path)
    day_of_week, date, hhmm = time.strftime("%a,%Y-%m-%d,%H:%M").split(',')
    columns = ["who_won_bid", "trump", "trick_points"] + \
              [f"{den}_{suit}" for den in Denominations for suit in Suit_names]
    with open(csv_path, 'at') as f:
        if not csv_exists:
            print(','.join(columns), "day_of_week", "date", "time",
                  sep=',', file=f)
        print(','.join(str(session[key]) for key in columns),
              day_of_week, date, hhmm, sep=',', file=f)
    redirect('/')


@get('/<page>')
def serve(page):
    print("serve called with", page)
    session = get_session()
    return template(page,
                    #player=player,
                    **session)


@get('/static/<filename>')
def static(filename):
    print("static called with", filename)
    return static_file(filename, root=STATIC_DIR)


bottle.TEMPLATE_PATH = [VIEWS_DIR]

#print("CODE_DIR", CODE_DIR)
#print("STATIC_DIR", STATIC_DIR)
#print("TEMPLATE_PATH", bottle.TEMPLATE_PATH)

run(host='0.0.0.0', port=8080, reloader=True, debug=True)
