import z from 'zod';

export const LeaderBoardEntrySchema = z.object({
  username: z.string(),
  score: z.number(),
  waterWasted: z.number(),
  waterConsumed: z.number()
})

export type LeadearboardEntry = z.infer<typeof LeaderBoardEntrySchema>;

export interface EntryEntity extends LeadearboardEntry {
  id: string,
}