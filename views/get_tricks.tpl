% rebase('base.tpl', title='Get Tricks')

<table>
<tr>
 <th colspan=2 style="color:red" class="right-border">&#x2665</th>  <!-- hearts -->
 <th colspan=2 class="right-border">&#x2660</th>  <!-- spades -->
 <th colspan=2 style="color:red" class="right-border">&#x2666</th>  <!-- diamonds -->
 <th colspan=2 class="right-border">&#x2663</th>  <!-- clubs -->
</tr>

% rows = []
% for i, suit in enumerate(("hearts", "spades", "diamonds", "clubs")):
% suit_melds = melds[suit]
% for j, (meld, count) in enumerate(sorted(suit_melds.items())):
% if len(rows) < j + 1:
%   rows.append([None, None, None, None])
% end
% rows[j][i] = (meld, count)
% end
% end
% rows.append([("Total", meld_points["hearts"]),
%              ("Total", meld_points["spades"]),
%              ("Total", meld_points["diamonds"]),
%              ("Total", meld_points["clubs"])])

% for row in rows:
<tr>
% for suit_col in row:
% if suit_col:
  <td>{{suit_col[0]}}:</td><td class="right-border">{{suit_col[1]}}</td>
% #  <td>{{suit_col}}</td>
% else:
  <td></td><td></td>
% end
% end
</tr>
% end

</table>

You have {{min(meld_points.values())}} meld points for a meld bid<br>
% my_meld_points = max(meld_points.values())
You have {{my_meld_points}} meld points if you are highest bidder<br>

<form method="post" action="/get_partner_meld">
<label>Partner's Meld Bid: <input type="number" name="partner_meld_bid" min="0" max="99"></label>
</form>

% if defined("partner_meld_bid"):
% partner_total = my_meld_points + 10 * partner_meld_bid
Total Meld Points: {{partner_total}}<br>

<table class="bids">
<tr>
  <th>21</th><td>{{partner_total + 21}}</td>
  <th>26</th><td>{{partner_total + 26}}</td>
  <th>31</th><td>{{partner_total + 31}}</td>
</tr>
<tr>
  <th>22</th><td>{{partner_total + 22}}</td>
  <th>27</th><td>{{partner_total + 27}}</td>
  <th>32</th><td>{{partner_total + 32}}</td>
</tr>
<tr>
  <th>23</th><td>{{partner_total + 23}}</td>
  <th>28</th><td>{{partner_total + 28}}</td>
  <th>33</th><td>{{partner_total + 33}}</td>
</tr>
<tr>
  <th>24</th><td>{{partner_total + 24}}</td>
  <th>29</th><td>{{partner_total + 29}}</td>
  <th>34</th><td>{{partner_total + 34}}</td>
</tr>
<tr>
  <th>25</th><td>{{partner_total + 25}}</td>
  <th>30</th><td>{{partner_total + 30}}</td>
  <th>35</th><td>{{partner_total + 35}}</td>
</tr>
</table>
% end

<form method="post" action="/get_tricks">

<label>Who won bid:<select name="who_won_bid">
<option value="me">Me</option>
<option value="partner">Partner</option>
<option value="opponents">Opponents</option>
</select>
</label><br>

<label>Trick Points Taken:<input type="number" name="trick_points" min="0" max="999"></label><br>

<button type="submit">Save</button>
</form>
