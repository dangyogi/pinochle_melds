<!-- % rebase('tournament_base.tpl', title='Count Meld') -->
% rebase('base.tpl', title='Count Cards', script='count_cards.js')

<form method="post" action="/count_cards">

<table class="striped full-width">
<tr style="font-size: 175%"><th class="right-border"></th>
<th colspan="5" style="color:red" class="right-border">&#x2665</th>  <!-- hearts -->
<th colspan="5" class="right-border">&#x2660</th>  <!-- spades -->
<th colspan="5" style="color:red" class="right-border">&#x2666</th>  <!-- diamonds -->
<th colspan="5" class="right-border">&#x2663</th>  <!-- clubs -->
</tr>
<tr class="bottom-border">
<th class="right-border"></th>
<th>0</th><th>1</th><th>2</th><th>3</th><th class="right-border">4</th>
<th>0</th><th>1</th><th>2</th><th>3</th><th class="right-border">4</th>
<th>0</th><th>1</th><th>2</th><th>3</th><th class="right-border">4</th>
<th>0</th><th>1</th><th>2</th><th>3</th><th class="right-border">4</th>
</tr>

% include('counts_suits.tpl', card_abbr='A', card='ace',
%         attr='onclick="update_counts(event)"',
%         last_class='right-border')

% include('counts_suits.tpl', card_abbr='10', card='ten',
%         attr='onclick="update_counts(event)"',
%         last_class='right-border')

% include('counts_suits.tpl', card_abbr='K', card='king',
%         attr='onclick="update_counts(event)"',
%         last_class='right-border')

% include('counts_suits.tpl', card_abbr='Q', card='queen',
%         attr='onclick="update_counts(event)"',
%         last_class='right-border')

% include('counts_suits.tpl', card_abbr='J', card='jack',
%         attr='onclick="update_counts(event)"',
%         row_class='bottom-border',
%         last_class='right-border')

</table>

<button id="submit_button" type="submit">Bid</button>

<span id="total">20</span> Total:
<span id="hearts">5</span> <span style="color:red; font-size: 130%">&#x2665</span>,
<span id="spades">4</span> <span style="font-size: 130%">&#x2660</span>,
<span id="diamonds">3</span> <span style="color:red; font-size: 130%">&#x2666</span>,
<span id="clubs">2</span> <span style="font-size: 130%">&#x2663</span>

</form>

<script>

card_counts["ace_hearts"] = 0;
card_counts["ace_spades"] = 0;
card_counts["ace_diamonds"] = 0;
card_counts["ace_clubs"] = 0;

card_counts["ten_hearts"] = 0;
card_counts["ten_spades"] = 0;
card_counts["ten_diamonds"] = 0;
card_counts["ten_clubs"] = 0;

card_counts["king_hearts"] = 0;
card_counts["king_spades"] = 0;
card_counts["king_diamonds"] = 0;
card_counts["king_clubs"] = 0;

card_counts["queen_hearts"] = 0;
card_counts["queen_spades"] = 0;
card_counts["queen_diamonds"] = 0;
card_counts["queen_clubs"] = 0;

card_counts["jack_hearts"] = 0;
card_counts["jack_spades"] = 0;
card_counts["jack_diamonds"] = 0;
card_counts["jack_clubs"] = 0;

sum_counts("hearts");
sum_counts("spades");
sum_counts("diamonds");
sum_counts("clubs");

update_total();

</script>
