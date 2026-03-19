const express = require('express');
const fs = require('fs/promises');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;
const dataFile = path.join(__dirname, 'data', 'scores.json');
const defaultData = require('./data/scores.json');

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

let writeQueue = Promise.resolve();

async function ensureDataFile() {
  try {
    await fs.access(dataFile);
  } catch {
    await fs.mkdir(path.dirname(dataFile), { recursive: true });
    await fs.writeFile(dataFile, JSON.stringify(defaultData, null, 2));
  }
}

async function readScores() {
  await ensureDataFile();
  const raw = await fs.readFile(dataFile, 'utf8');
  return JSON.parse(raw);
}

function writeScores(nextData) {
  writeQueue = writeQueue.then(async () => {
    await fs.writeFile(dataFile, JSON.stringify(nextData, null, 2));
    return nextData;
  });

  return writeQueue;
}

function touchUpdatedAt(data) {
  return {
    ...data,
    updatedAt: new Date().toISOString()
  };
}

function findTeam(data, teamId) {
  return data.teams.find((team) => team.id === teamId);
}

app.get('/api/scores', async (_req, res, next) => {
  try {
    const data = await readScores();
    res.json(data);
  } catch (error) {
    next(error);
  }
});

app.post('/api/scores/team/:teamId', async (req, res, next) => {
  try {
    const amount = Number(req.body.amount);
    if (!Number.isFinite(amount)) {
      return res.status(400).json({ error: 'Amount must be a valid number.' });
    }

    const data = await readScores();
    const team = findTeam(data, req.params.teamId);
    if (!team) {
      return res.status(404).json({ error: 'Team not found.' });
    }

    team.score = Math.max(0, team.score + amount);
    const saved = await writeScores(touchUpdatedAt(data));
    res.json(saved);
  } catch (error) {
    next(error);
  }
});

app.post('/api/scores/team/:teamId/reset', async (req, res, next) => {
  try {
    const data = await readScores();
    const team = findTeam(data, req.params.teamId);
    if (!team) {
      return res.status(404).json({ error: 'Team not found.' });
    }

    team.score = 0;
    const saved = await writeScores(touchUpdatedAt(data));
    res.json(saved);
  } catch (error) {
    next(error);
  }
});

app.post('/api/scores/reset', async (_req, res, next) => {
  try {
    const data = await readScores();
    data.teams.forEach((team) => {
      team.score = 0;
    });
    const saved = await writeScores(touchUpdatedAt(data));
    res.json(saved);
  } catch (error) {
    next(error);
  }
});

app.use((error, _req, res, _next) => {
  console.error(error);
  res.status(500).json({ error: 'Something went wrong while updating scores.' });
});

app.listen(port, () => {
  console.log(`CVC Youth Scoreboard is running on port ${port}`);
});
