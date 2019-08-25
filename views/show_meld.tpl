% rebase('base.tpl', title='Show Meld')

<table>
<tr><th>Meld</th><th>Count</th><th>Points</th>
    <th>Meld</th><th>Count</th><th>Points</th>
</tr>
% for i, (meld, (number, points)) in enumerate(melds[trump].items()):
% if i % 2 == 0:
<tr>
% end
<th>{{meld}}</th><td>{{number}}</td><td>{{points}}</td>
% if i % 2 == 1:
</tr>
% end
% if i % 2 == 0:
</tr>
% end
% end
</table>

You have {{meld_points[trump]}} meld points.

<form method="post" action="/show_meld">
<label>Trick Points: <input type="number" name="trick_points" min="0" max="50"
value="0">
</label>
</form>
