import fs from 'fs';
import { EntryEntity, LeadearboardEntry } from "../schema";

const filePath = './db.json';
let data: Array<EntryEntity> = [];

if (fs.existsSync(filePath)) {
  const loadedFile = fs.readFileSync(filePath, { encoding: 'utf-8' });
  data = JSON.parse(loadedFile);
}

const addEntry = (entry: LeadearboardEntry) => {
  data.push({
    id: crypto.randomUUID(),
    ...entry,
  });
  data.sort((a,b) => b.score - a.score);
  save();
}

const deleteEntry = (id: string) => {
  data = data.filter((item) => item.id !== id);
  save();
}

const getAll = () => {
  return data;
}

const save = () => {
  fs.writeFileSync(filePath, JSON.stringify(data), { encoding: 'utf-8' });
}

export const db = {
  deleteEntry,
  addEntry,
  getAll
}