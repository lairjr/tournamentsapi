import { randomString } from "../utils/random";

const randomPhase = (tournamentId: string) => ({
  title: randomString(),
  tournament_id: tournamentId,
  type: Math.round(Math.random() * 1) ? "elimination" : "draw",
});

export const phasePayload = (tournamentId: string) => (
  {
    phase: randomPhase(tournamentId),
  });
