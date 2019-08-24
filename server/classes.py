# classes.py


import time


Current_Tournament = None


class Tournament:
    def __init__(self, number_tables):
        global Current_Tournament
        self.start_time = time.strftime("%a %b %d, %I:%M %p")
        self.number_tables = number_tables
        self.tables = tuple(Table(t) for t in range(1, number_tables + 1))
        self.done = False
        if Current_Tournament is None:
            Current_Tournament = self
        else:
            # FIX: Check that number_tables is the same?
            # FIX: Check start_time not too old?
            pass

    def get_table(self, table_number):
        return self.tables[table_number - 1]

    def get_game_with_player(self, player):
        '''Returns the Game with player.

        Returns None if the player is not currently assigned to any game.
        '''
        for t in self.tables:
            game = t.active_game()
            if game and game.has_player(player):
                return game
        return None

    def finished(self):
        self.done = True
        # FIX: Save Tournament!
        self.abort()

    def abort(self):
        global Current_Tournament
        Current_Tournament = None


class Table:
    '''Represents a Pinochle table in a Tournament.
    '''
    def __init__(self, table_number):
        self.table_number = table_number
        self.games = []

    def add_partners(self, partner1, partner2):
        if not self.games or self.games[-1].status == 'done':
            self.games.append(Game(self.table_number, partner1, partner2))
        else:
            self.games[-1].add_partners(partner1, partner2)

    def active_game(self):
        '''Returns the most recent game that has been started.

        Returns None if no game has been started yet.
        '''
        if self.games:
            return self.games[-1]
        return None


class Game:
    def __init__(self, table_number, partner1, partner2):
        self.table_number = table_number
        self.partners = []
        self.add_partners(partner1, partner2)
        self.hands = []
        self.status = 'init'

    def has_player(self, player):
        return self.status != 'done' and self.get_partners(player) is not None

    def partner(self, player):
        '''Returns None if player not in this game.
        '''
        partners = self.get_partners(player)
        if partners:
            return partners.partner(player)
        return None

    def get_partners(self, player):
        '''Return Partners object with player.

        Returns None if there are no Partners objects with player.
        '''
        for p in self.partners:
            if p.has_player(player):
                return p
        return None

    def add_partners(self, partner1, partner2):
        p1 = self.get_partners(partner1)
        p2 = self.get_partners(partner2)
        assert p1 is p2, "New partnership conflicts with existing partnerships"
        if p1 is None:
            assert len(self.partners) < 2, "Already two partnerships"
            self.partners.append(Partners(self, partner1, partner2))

    def start(self):
        assert self.status != 'done'
        self.status = 'started'

    def done(self):
        assert self.status != 'init'
        self.status = 'done'

    def trump(self):
        hand = self.get_hand()
        if hand is not None:
            return hand.trump
        return None

    def get_hand(self):
        if not self.hands or self.hands[-1].done and len(self.hands) < 4:
            self.hands.append(Hand(self))
        if self.hands:
            return self.hands[-1]
        return None


class Hand:
    def __init__(self, game):
        self.game = game
        self.done = False
        self.trump = None
        self.bid = None
        self.player_melds = {}  # {player: melds},
                                # melds includes:
                                #   meld_points, validated_by, invalidated_by,
                                #   hints

    def store_meld(self, player, meld_points, **melds):
        melds = melds.copy()
        melds['meld_points'] = meld_points
        melds['validated_by'] = []
        melds['invalidated_by'] = []
        self.player[player] = melds


class Partners:
    def __init__(self, game, partner1, partner2):
        self.game = game
        self.partner1 = partner1
        self.partner2 = partner2

    def has_player(self, player):
        return player in (self.partner1, self.partner2)

    def partner(self, player):
        assert self.has_player(player)
        if player == self.partner1:
            return self.partner2
        return self.partner1

