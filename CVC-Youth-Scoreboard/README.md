# CVC Youth Scoreboard

A PHP scoreboard app for tracking six youth division scores with two pages:

- `index.php` — scorekeeper admin page to update scores.
- `viewer.php` — read-only public display page for spectators.

## Features

- Six preconfigured teams/divisions with large, color-coded score cards.
- Quick buttons for `+1`, `+3`, `+5`, `+10`, `-1`, `-3`, `-5`, and `-10`.
- Custom positive or negative score entry for each team.
- Reset one team or reset all teams at once.
- Scores saved to `data/scores.json` after each change.
- Viewer page automatically refreshes every 2 seconds.
- Responsive layout that fills large screens and adapts to phones/tablets.
- Multiple scorekeepers supported via file locking.

## Run locally

```bash
cd CVC-Youth-Scoreboard
php -S 127.0.0.1:8000
```

Then open:

- `http://127.0.0.1:8000/` for the admin page.
- `http://127.0.0.1:8000/viewer.php` for the viewer page.

## Deploying to `jasr.me/scoreboard`

Upload the contents of `CVC-Youth-Scoreboard` into your `scoreboard` folder on the host so that these URLs exist:

- `https://jasr.me/scoreboard/` — admin page
- `https://jasr.me/scoreboard/viewer.php` — viewer page

Make sure the `data` folder is writable by PHP so the app can update `data/scores.json`.
