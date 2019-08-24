% include('count_cell.tpl', name=name, value=0)
% include('count_cell.tpl', name=name, value=1)
% include('count_cell.tpl', name=name, value=2)
% include('count_cell.tpl', name=name, value=3)
% if defined('last_class'):
% include('count_cell.tpl', name=name, class_=last_class, value=4)
% else:
% include('count_cell.tpl', name=name, value=4)
% end
