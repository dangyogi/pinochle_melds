% if defined('row_class'):
<tr class="{{row_class}}">
% else:
<tr>
% end
<th class="right-border">{{card_abbr}}</th>
% include('counts.tpl', name=card + '_hearts')
% include('counts.tpl', name=card + '_spades')
% include('counts.tpl', name=card + '_diamonds')
% include('counts.tpl', name=card + '_clubs')
</tr>
