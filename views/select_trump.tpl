<label>Trump: <select name="trump">
% for suit in suits:
% if get('trump', None) == suit:
<option value="{{suit}}" selected>\\
% else:
<option value="{{suit}}">\\
% end
{{suit.title()}}</option>
% end
</select>
</label>
