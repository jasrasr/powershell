<?php

declare(strict_types=1);

require __DIR__ . '/scoreboard_lib.php';

$action = $_GET['action'] ?? 'scores';
$teamId = $_GET['team'] ?? '';
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

try {
    if ($method === 'GET' && $action === 'scores') {
        jsonResponse(readScoreboardData());
    }

    if ($method !== 'POST') {
        jsonResponse(['error' => 'Method not allowed.'], 405);
    }

    if ($action === 'update') {
        $payload = readJsonRequestBody();
        $amount = $payload['amount'] ?? null;
        if (!is_numeric($amount)) {
            jsonResponse(['error' => 'Amount must be a valid number.'], 400);
        }

        $saved = writeScoreboardData(function (array $data) use ($teamId, $amount): array {
            $teamIndex = findTeamIndex($data, $teamId);
            if ($teamIndex === null) {
                throw new InvalidArgumentException('Team not found.');
            }

            $newScore = (int) ($data['teams'][$teamIndex]['score'] ?? 0) + (int) $amount;
            $data['teams'][$teamIndex]['score'] = max(0, $newScore);

            return $data;
        });

        jsonResponse($saved);
    }

    if ($action === 'reset-team') {
        $saved = writeScoreboardData(function (array $data) use ($teamId): array {
            $teamIndex = findTeamIndex($data, $teamId);
            if ($teamIndex === null) {
                throw new InvalidArgumentException('Team not found.');
            }

            $data['teams'][$teamIndex]['score'] = 0;
            return $data;
        });

        jsonResponse($saved);
    }

    if ($action === 'reset-all') {
        $saved = writeScoreboardData(function (array $data): array {
            foreach ($data['teams'] as &$team) {
                $team['score'] = 0;
            }
            unset($team);

            return $data;
        });

        jsonResponse($saved);
    }

    jsonResponse(['error' => 'Unknown action.'], 404);
} catch (InvalidArgumentException $exception) {
    jsonResponse(['error' => $exception->getMessage()], 404);
} catch (Throwable $exception) {
    jsonResponse(['error' => 'Something went wrong while updating scores.'], 500);
}
