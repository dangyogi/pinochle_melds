% rebase('base.tpl', title='Meld')

<form method="post" action="/pinochle/meld">
<label>Who won bid:<select name="who_won_bid">
% if get('who_won_bid', None) == 'me':
  <option value="me" selected>Me</option>
  <option value="partner">Partner</option>
% else:
  <option value="me">Me</option>
  <option value="partner" selected>Partner</option>
% end
  <option value="opponents">Opponents</option>
</select>
</label><br>
% include("select_trump.tpl")
<button type="submit">Show Meld</button>
</form>

