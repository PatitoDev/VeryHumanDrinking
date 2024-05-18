import { db } from "../db";
import { LeadearboardEntry } from "../schema";

export const newEntryHandler = (entry: LeadearboardEntry) => {
  db.addEntry(entry);
}