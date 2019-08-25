<!doctype html>
<html lang="en">
<head>
  <title>{{title or 'No Title'}}</title>
  <meta name="viewport" content="width=device-width, initial-scale={{get('initial_scale', 1.0)}}">
  <link rel="stylesheet" href="/static/base.css">
% if defined("script"):
  <script type="text/javascript" src="/static/{{script}}"></script>
% end
</head>
<body>
% if get('player', None) is not None:
<h3>Player: {{player}}</h3>
% if get('partner', None) is not None:
<h3>Partner: {{partner}}</h3>
% end
% end
{{!base}}
</body>
</html>
