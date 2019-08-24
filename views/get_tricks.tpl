% rebase('base.tpl', title='Get Tricks')


<form method="post" action="/get_tricks">
<label>#Trump cards: <input type="number" name="trump" min="0" max="20"></label><br>
<label>#Trump Aces:<input type="number" name="trump_aces" min="0" max="4"></label><br>
<label>#Aces:<input type="number" name="aces" min="0" max="16"></label><br>
<label>Who won bid:<select name="who_won_bid">
<option value="me">Me</option>
<option value="partner">Partner</option>
<option value="opponents">Opponents</option>
</select>
</label><br>
<label>Trick Points Taken:<input type="number" name="trick_points" min="0" max="999"></label><br>

<button type="submit">Save</button>
</form>
