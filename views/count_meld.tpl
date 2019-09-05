<!-- % rebase('tournament_base.tpl', title='Count Meld') -->
% rebase('base.tpl', title='Count Meld')

<form method="post" action="/pinochle/count_meld">

<table>
<tr><th></th><th>0</th><th>1</th><th>2</th><th>3</th><th>4</th></tr>

% include('counts_row.tpl', label='Runs', name='runs')
% include('counts_row.tpl', label='4 Aces', name='aces', max=3)
% include('counts_row.tpl', label='4 Kings', name='kings', max=3)
% include('counts_row.tpl', label='4 Queens', name='queens', max=3)
% include('counts_row.tpl', label='4 Jacks', name='jacks', max=3)
% include('counts_row.tpl', suit='\u2663', name='club_marriages')
% include('counts_row.tpl', suit='\u2660', name='spade_marriages')
% include('counts_row.tpl', suit='\u2666', name='diamond_marriages', color='red')
% include('counts_row.tpl', suit='\u2665', name='heart_marriages', color='red')
% include('counts_row.tpl', label='Pinochles', name='pinochles')
% include('counts_row.tpl', label='15 Cards', name='cards_15', max=1)
% include('counts_row.tpl', label="Partner's Meld Bid", name='partners_meld_bid')

</table>

<label>Trump: <select name="trump">
<option value=""></option>
<option value="hearts"
% if get('trump', None) == 'hearts':
selected
% end
>Hearts</option>
<option value="spades"
% if get('trump', None) == 'spades':
selected
% end
>Spades</option>
<option value="diamonds"
% if get('trump', None) == 'diamonds':
selected
% end
>Diamonds</option>
<option value="clubs"
% if get('trump', None) == 'clubs':
selected
% end
>Clubs</option>
</select>
</label>

<button type="submit">Total</button>
<!--
<button type="submit" name="action" value="total">Total</button>
% #if hand.bid is not None:
<button type="submit" name="action" value="final">Final</button>
% #end
-->

</form>

<!--
% #if hand.bid is None:
% #include('button.tpl', method='get', url='/get_bid', label='Record Bid')
% #end
-->

% if defined('total'):
Your Total Meld: {{total}}<br>
Your Meld for Bidding: {{total - run_points + your_meld_bid_offset}}<br>
With Partner's Meld: {{partner_total}}

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

<form action="/pinochle/get_tricks">
<button type="submit">Record Tricks</button>
</form>
