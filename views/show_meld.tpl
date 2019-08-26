% rebase('base.tpl', title='Show Meld')

<table class="show_meld">
<tr><th>Meld</th><th>Count</th><th class="red_right">Points</th>
    <th>Meld</th><th>Count</th><th>Points</th>
</tr>
% for i, (meld, (number, points)) in enumerate(melds[trump].items()):
% if i % 2 == 0:
<tr>
% end
<th>{{meld}}</th><td>{{number}}</td><td \\
% if i % 2 == 0:
class="red_right"\\
% end
>{{points}}</td>
% if i % 2 == 1:
</tr>
% end
% if i % 2 == 0:
</tr>
% end
% end
</table>

You have {{meld_points[trump]}} total meld points.

<form method="post" action="/show_meld">
<label>Trick Points Taken: <input type="number" name="trick_points" min="0" max="50">
</label>
</form>
