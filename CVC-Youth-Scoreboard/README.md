# CVC Youth Scoreboard

A small Node/Express web app for tracking six youth division scores with two pages:

- `/` for scorekeepers to update scores.
- `/viewer.html` for a read-only public display page.

## Features

- Six preconfigured teams/divisions with large, color-coded score cards.
- Quick buttons for `+1`, `+3`, `+5`, `+10`, `-1`, `-3`, `-5`, and `-10`.
- Custom positive or negative score entry for each team.
- Reset one team or reset all teams.
- Scores saved to `data/scores.json` after each change.
- Viewer page automatically refreshes every 2 seconds.
- Responsive layout that fills large screens and adapts to phones/tablets.

## Run locally

```bash
cd CVC-Youth-Scoreboard
npm install
npm start
```

Then open:

- `http://localhost:3000/` for the admin page.
- `http://localhost:3000/viewer.html` for the viewer page.

## Hosting notes

Because this app writes to a JSON file, it needs a host that supports running Node.js server-side code and allows file writes to the app directory or a writable data location.

If you later move it to `jasr.me/scoreboard`, point that path at this app and keep `data/scores.json` writable.
