import express from 'express';
import { LeaderBoardEntrySchema } from './schema';
import { newEntryHandler } from './handlers/newEntryHandler';
import { getLeaderboardHandler } from './handlers/getLeaderboardHandler';
import { db } from './db';
import dotenv from 'dotenv';

dotenv.config();

const SECRET = process.env.SECRET;
const PORT = process.env.PORT;

const app = express();

app.use(express.json());

app.use('/', (req, res, next) => {
  console.log(`[${req.method}] - ${req.path}`);
  next();
});

app.post('/entry', (req, res) => {
  try {
    const entry = LeaderBoardEntrySchema.parse(req.body);
    newEntryHandler(entry);
    res.status(201).send();
  }
  catch(e) {
    console.log('bad request', e);
    res.status(400).send();
  }
})

app.get('/entry', (req, res) => {
try {
    const leaderboard = getLeaderboardHandler();
    res.status(200).send(leaderboard);
  }
  catch(e) {
    console.log('bad request', e);
    res.status(400).send();
  }
})

app.delete('/entry/:id', (req, res) => {
  try {
    if (req.headers.authorization !== SECRET) {
      return res.status(403).send();
    }
    db.deleteEntry(req.params.id);
    res.status(200).send();

  } catch(e) {
    console.log('bad request', e);
    res.status(400).send();
  }
})

app.listen(PORT, () => {
  console.log(`Server started at http://localhost:${PORT}`);
})