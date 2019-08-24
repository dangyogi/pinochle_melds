% rebase('base.tpl', title=title)

% if defined('tournament'):
<h4>Tournament: {{tournament.start_time}}</h4>

% if defined('hand') and hand.bid is not None:
Bid: {{hand.bid}}<br>
Trump: {{hand.trump}}<br>
% end

{{!base}}

% include('button.tpl', url='/tournament_done', label="Tournament Done!")

% else:

<h4>Tournament: <span style="color:red">Not Started!</span></h4>

% include('start_tournament_body.tpl')

% end
