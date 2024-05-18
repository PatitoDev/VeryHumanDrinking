import { db } from "../db"

export const getLeaderboardHandler = () => {
  return db.getAll();
}