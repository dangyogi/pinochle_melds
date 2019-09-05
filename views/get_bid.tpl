% rebase('tournament_base.tpl', title='Get Bid')

% if hand.bid is None:

<form method="post" action="/pinochle/get_bid">
<label>Bid:<input type="number" name="bid" min="50" max="999"></label>

% include("select_trump.tpl")

<button type="submit">Bid</button>
</form>

% else:

<form method="post" action="/pinochle/store_hints">
<label>Number of Trump<input type="number" name="trump" min="0" max="20"></label>
<label>Number of Trump Aces<input type="number" name="trump_aces" min="0" max="4"></label>
<label>Total Aces<input type="number" name="aces" min="0" max="16"></label>
<button type="submit">Trick Hints</button>
</form>

% end
