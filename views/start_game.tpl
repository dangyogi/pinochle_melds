% rebase('tournament_base.tpl', title='Start Game')


<h3>Start Game</h3>

<form method="post" action="/start_game">
<label>Table Number:
<input type="number" name="table" min="1" max="9" value="1">
</label>
<label>Partner: <input type="text" name="partner"></label>
<button type="submit">Start Game</button>
</form>
