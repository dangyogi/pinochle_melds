<tr>
% if defined('suit'):
  % if defined('color'):
    <th><span style="color:{{color}}">{{suit}}</span> Marriages</th>
  % else:
    <th>{{suit}} Marriages</th>
  % end
% else:
  <th>{{label}}</th>
% end

% include('counts.tpl')
</tr>
