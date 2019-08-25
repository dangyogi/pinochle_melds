% rebase('base.tpl', title='Make Bid')

<table>
<tr>
<td class="right-border fat-border">
<form method="post" action="/make_bid">
<label>Partner's Meld Bid:
<table>
<tr>
% for i in range(7):
<th>{{i}}</th>
% end
</tr>
<tr>
% for i in range(7):
<td><input type="radio" name="partners_meld_bid" value="{{i}}" \\
% if i == 0:
checked\\
% end
></td>
% end
</tr>
</table>
</label>
% include("select_trump.tpl")
<br>
<button type="submit">Show Bids</button>
</form>
</td>
<td>
You have {{min(meld_points.values())}} meld points to bid.<br>
<a href="/meld">Meld</a>
</td>
</tr>
</table>
