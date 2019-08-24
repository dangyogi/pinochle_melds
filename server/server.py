# server.py

'''There are two cookies:

NAME (max_age=1 year)
CONTEXT (session)
'''

import os
import time

import bottle
from bottle import (
    get, post, request, response, redirect, run, template, static_file,
    HTTPError
)

#from . import classes
import classes


SECRET = 'asdlfj;l3kj4lkjsrouzghypaob8usoaru7b0SDFWERSXBBBBBu1'
CODE_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(CODE_DIR)
STATIC_DIR = os.path.join(PROJECT_DIR, "static")
VIEWS_DIR = os.path.join(PROJECT_DIR, "views")
YEAR = 365*24*60*60


def get_player():
    name = request.get_cookie('name', secret=SECRET)
    print("name", name)
    return name


@get('/favicon.ico')
def favicon():
    raise HTTPError(404, 'Not Found');


@get('/')
def home():
    print("home called")
    #player = get_player()
    #if player is None:
    #    redirect('/get_name')
    #else:
    #    return got_name(player)
    redirect('/count_meld')


def got_name(player):
    print("got_name called")
    if classes.Current_Tournament is None:
        redirect('/start_tournament')
    else:
        redirect('/tournament_home')


@post('/get_name')
def get_name():
    print("get_name called")
    name = request.forms.name
    if name:
        print(name, "logged in")
        response.set_cookie('name', name, max_age=YEAR, secret=SECRET)
        return got_name(name)
    print("name not found, forms keys", tuple(request.forms.keys()))
    redirect('/get_name')


@post('/start_tournament')
def start_tournament():
    print("start_tournament called")
    if classes.Current_Tournament is not None:
        redirect('/tournament_home')
    tables = request.forms.tables
    if tables:
        number_tables = int(tables)
        print("number_tables", repr(number_tables))
        classes.Tournament(number_tables)
        redirect('/tournament_home')
    redirect('/start_tournament')


def check_tournament():
    if classes.Current_Tournament is None:
        print("Tournament Ended")
        redirect("/start_tournament")


@post('/tournament_done')
def tournament_done():
    print("tournament_done called")
    check_tournament()
    classes.Current_Tournament.finished()
    return abort_tournament()


@post('/abort_tournament')
def abort_tournament():
    print("abort_tournament called")
    check_tournament()
    classes.Current_Tournament.abort()
    redirect("/start_tournament")


@get('/start_game')
def start_game():
    print("start_game called")
    check_tournament()
    player = get_player()
    if classes.Current_Tournament.get_game_with_player(player):
        redirect("/count_meld")
    else:
        return serve("start_game")


@post('/start_game')
def start_game2():
    print("start_game2 called")
    check_tournament()
    player = get_player()
    table_number = request.forms.table
    partner = request.forms.partner
    if table_number and partner:
        table_number = int(table_number)
        print("table_number", repr(table_number), "player", player,
              "partner", partner)
        table = classes.Current_Tournament.get_table(table_number)
        table.add_partners(player, partner)
        redirect("/count_meld")
    else:
        return start_game()


@post('/count_meld')
def count_meld():
    print("count_meld called")
    #check_tournament()
    #player = get_player()
    #game = classes.Current_Tournament.get_game_with_player(player)
    #if game is None:
    #    redirect('/start_game')
    #game.start()
    #hand = game.get_hand()
    #if hand is None or hand.done:
    #    redirect('/start_game')

    runs = int(request.forms.runs)
    aces = int(request.forms.aces)
    kings = int(request.forms.kings)
    queens = int(request.forms.queens)
    jacks = int(request.forms.jacks)
    club_marriages = int(request.forms.club_marriages)
    spade_marriages = int(request.forms.spade_marriages)
    diamond_marriages = int(request.forms.diamond_marriages)
    heart_marriages = int(request.forms.heart_marriages)
    pinochles = int(request.forms.pinochles)
    cards_15 = int(request.forms.cards_15)
    trump = request.forms.trump
    #trump = game.trump()

    melds = dict(runs=runs,
                 aces=aces, kings=kings, queens=queens, jacks=jacks,
                 club_marriages=club_marriages,
                 spade_marriages=spade_marriages,
                 diamond_marriages=diamond_marriages,
                 heart_marriages=heart_marriages,
                 pinochles=pinochles,
                 cards_15=cards_15,
                 trump=trump,
                )

    partners_meld_bid = int(request.forms.partners_meld_bid)
    #action = request.forms.action

    round_houses = min(club_marriages, spade_marriages, diamond_marriages,
                       heart_marriages)

    print("runs", runs)
    print("aces", aces)
    print("kings", kings)
    print("queens", queens)
    print("jacks", jacks)
    print("round_houses", round_houses)
    print("club_marriages", club_marriages - round_houses)
    print("spade_marriages", spade_marriages - round_houses)
    print("diamond_marriages", diamond_marriages - round_houses)
    print("heart_marriages", heart_marriages - round_houses)
    print("pinochles", pinochles)
    print("cards_15", cards_15)
    print("partners_meld_bid", partners_meld_bid)
    print("trump", trump)
    #print("action", action)

    total = 0

    run_points = (0, 15, 150, 300) [runs]
    total += run_points
    total += (0, 10, 100, 200) [aces]
    total += (0, 8, 80, 160) [kings]
    total += (0, 6, 60, 120) [queens]
    total += (0, 4, 40, 80) [jacks]

    # Q: assumed: Trump marriages don't count extra in Round Houses

    your_meld_bid_offset = 0

    def count_marriages(suit, count):
        nonlocal your_meld_bid_offset
        if count < 3:
            count -= round_houses
            if suit == trump and count == 1:
                # Marriage already counted in Run
                #
                # If count == 2, one marriage is already counted, and the
                # other counts double, so leave count at 2.
                count = 0
                your_meld_bid_offset = 2
        ans = (0, 2, 4, 60, 120) [count]
        print("count_marriages", count, suit, "->", ans)
        return ans

    total += count_marriages('clubs', club_marriages)
    total += count_marriages('spades', spade_marriages)
    total += count_marriages('diamonds', diamond_marriages)
    total += count_marriages('hearts', heart_marriages)

    total += (0, 24, 48) [round_houses]
    total += (0, 4, 30, 60, 120) [pinochles]
    total += (0, 300) [cards_15]
    partner_total = total + 10 * partners_meld_bid

    #if action == 'total':
    if True:
        return template('count_meld',
                        #player=player,
                        #tournament=classes.Current_Tournament,
                        #game=game,
                        #hand=hand,
                        partners_meld_bid=partners_meld_bid,
                        total=total, run_points=run_points,
                        your_meld_bid_offset=your_meld_bid_offset,
                        partner_total=partner_total,
                        **melds
                       )
    #assert action == 'final'
    #hand.store_meld(player, total, **melds)
    #return serve('count_meld')


@post('/get_tricks')
def get_tricks():
    print("get_tricks called")
    trump_aces = request.forms.trump_aces
    trump = request.forms.trump
    aces = request.forms.aces
    who_won_bid = request.forms.who_won_bid
    trick_points = request.forms.trick_points
    print("get_tricks got", trump_aces, trump, aces, who_won_bid, trick_points)
    csv_path = os.path.join(PROJECT_DIR, 'trick_hints.csv')
    csv_exists = os.path.exists(csv_path)
    day_of_week, date, hhmm = time.strftime("%a,%Y-%m-%d,%H:%M").split(',')
    with open(csv_path, 'at') as f:
        if not csv_exists:
            print("trump", "trump_aces", "aces", "who_won_bid", "trick_points",
                  "day_of_week", "date", "time", sep=',', file=f)
        print(trump, trump_aces, aces, who_won_bid, trick_points,
              day_of_week, date, hhmm, sep=',', file=f)
    redirect('/count_meld')


@post('/get_bid')
def get_bid():
    print("get_bid called")
    check_tournament()
    player = get_player()
    game = classes.Current_Tournament.get_game_with_player(player)
    if game is None:
        redirect('/start_game')
    hand = game.get_hand()
    bid = request.forms.bid
    trump = request.forms.trump
    print("get_bid got", repr(bid), repr(trump))
    if hand is None or hand.done:
        redirect('/start_game')
    if bid:
        hand.bid = int(bid)
        hand.trump = trump
    redirect('/get_bid')


@post('/store_hints')
def store_hints():
    print("store_hints called")
    check_tournament()
    player = get_player()
    game = classes.Current_Tournament.get_game_with_player(player)
    if game is None:
        redirect('/start_game')
    hand = game.get_hand()
    trump = request.forms.trump
    trump_aces = request.forms.trump_aces
    aces = request.forms.aces
    print("store_hints got", repr(trump), repr(trump_aces), repr(aces))
    if hand is None or hand.done:
        redirect('/start_game')
    if trump and trump_aces and aces:
        hand.player_melds[player]['hints'] = dict(trump=int(trump),
                                                  trump_aces=int(trump_aces),
                                                  aces=int(aces),
                                                 )
    redirect('/score_meld')


@get('/<page>')
def serve(page):
    print("serve called with", page)
    player = get_player()
    rest = {}
    if classes.Current_Tournament is not None:
        rest['tournament'] = classes.Current_Tournament
        game = classes.Current_Tournament.get_game_with_player(player)
        if game is not None:
            rest['game'] = game
            partner = game.partner(player)
            rest['partner'] = partner
            hand = game.get_hand()
            if hand is not None:
                rest['hand'] = hand
    return template(page, player=player, **rest)


@get('/static/<filename>')
def static(filename):
    print("static called with", filename)
    return static_file(filename, root=STATIC_DIR)


bottle.TEMPLATE_PATH = [VIEWS_DIR]

#print("CODE_DIR", CODE_DIR)
#print("STATIC_DIR", STATIC_DIR)
#print("TEMPLATE_PATH", bottle.TEMPLATE_PATH)

run(host='0.0.0.0', port=8080, reloader=True, debug=True)
