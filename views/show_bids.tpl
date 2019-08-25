% rebase('base.tpl', title='Show Bids')

% partner_total = meld_points[trump] + 10 * partners_meld_bid

You have {{partner_total}} total partnership meld points.

<table class="bids striped">
% for row in range(11, 16):
<tr>
% for col in range(6):
% trick_points = row + 5 * col
  <th>{{trick_points}}</th><td>{{partner_total + trick_points}}</td>
% end
</tr>
% end
</table>

<a href="/meld">Meld</a>
