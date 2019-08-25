<!-- % rebase('tournament_base.tpl', title='Count Meld') -->
% rebase('base.tpl', title='Count Cards', script='count_cards.js')

<form method="post" action="/count_cards">

<table class="striped full-width">
<tr style="font-size: 135%"><th class="right-border"></th>
% for span in suit_spans:
<th colspan="5" class="right-border">{{!span}}</th>
% end
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
% for i, (suit, span) in enumerate(zip(suits, suit_spans)):
<span id="{{suit}}">0</span> {{!span}}\\
% if i < 3:
,
% end
% end

</form>

<script>

card_counts["ace_hearts"] = {{get("ace_hearts", 0)}};
card_counts["ace_spades"] = {{get("ace_spades", 0)}};
card_counts["ace_diamonds"] = {{get("ace_diamonds", 0)}};
card_counts["ace_clubs"] = {{get("ace_clubs", 0)}};

card_counts["ten_hearts"] = {{get("ten_hearts", 0)}};
card_counts["ten_spades"] = {{get("ten_spades", 0)}};
card_counts["ten_diamonds"] = {{get("ten_diamonds", 0)}};
card_counts["ten_clubs"] = {{get("ten_clubs", 0)}};

card_counts["king_hearts"] = {{get("king_hearts", 0)}};
card_counts["king_spades"] = {{get("king_spades", 0)}};
card_counts["king_diamonds"] = {{get("king_diamonds", 0)}};
card_counts["king_clubs"] = {{get("king_clubs", 0)}};

card_counts["queen_hearts"] = {{get("queen_hearts", 0)}};
card_counts["queen_spades"] = {{get("queen_spades", 0)}};
card_counts["queen_diamonds"] = {{get("queen_diamonds", 0)}};
card_counts["queen_clubs"] = {{get("queen_clubs", 0)}};

card_counts["jack_hearts"] = {{get("jack_hearts", 0)}};
card_counts["jack_spades"] = {{get("jack_spades", 0)}};
card_counts["jack_diamonds"] = {{get("jack_diamonds", 0)}};
card_counts["jack_clubs"] = {{get("jack_clubs", 0)}};

sum_counts("hearts");
sum_counts("spades");
sum_counts("diamonds");
sum_counts("clubs");

update_total();

</script>
