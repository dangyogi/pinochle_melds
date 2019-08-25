% rebase('base.tpl', title='Meld')

<form method="post" action="/meld">
<label>Who won bid:<select name="who_won_bid">
<option value="me" selected>Me</option>
<option value="partner">Partner</option>
<option value="opponents">Opponents</option>
</select>
</label><br>
% include("select_trump.tpl")
<button type="submit">Show Meld</button>
</form>

