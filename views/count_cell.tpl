% if defined('class_'):
  <td class="{{class_}}">
% else:
  <td>
% end

% if get('max', 4) >= value:
  <input type="radio" name="{{name}}" value="{{value}}" \\
    % if get(name, 0) == value:
      checked \\
    % end
    % if defined('attr'):
      {{!attr}}\\
    % end
>
% end
</td>
