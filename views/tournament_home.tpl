% rebase('tournament_base.tpl', title='Tournament')

<form method="post" action="/pinochle/start_game">
<label>Table Number:
<input type="number" name="table" min="1" max="9" value="1">
</label>
<label>Partner: <input type="text" name="partner"></label>
<button type="submit">Start Game</button>
</form>

% include('button.tpl', url='/abort_tournament', label='OOPS!!  Abort Tournament...')

