<?php

declare(strict_types=1);

const SCOREBOARD_DATA_FILE = __DIR__ . '/data/scores.json';

function scoreboardDefaultData(): array
{
    return [
        'title' => 'CVC Youth Scoreboard',
        'updatedAt' => null,
        'teams' => [
            [
                'id' => 'sixth-grade-boys',
                'name' => '6th Grade Boys',
                'color' => '#1d4ed8',
                'score' => 0,
            ],
            [
                'id' => 'sixth-grade-girls',
                'name' => '6th Grade Girls',
                'color' => '#db2777',
                'score' => 0,
            ],
            [
                'id' => 'seventh-grade-boys',
                'name' => '7th Grade Boys',
                'color' => '#0f766e',
                'score' => 0,
            ],
            [
                'id' => 'seventh-grade-girls',
                'name' => '7th Grade Girls',
                'color' => '#7c3aed',
                'score' => 0,
            ],
            [
                'id' => 'eighth-grade-boys',
                'name' => '8th Grade Boys',
                'color' => '#ea580c',
                'score' => 0,
            ],
            [
                'id' => 'eighth-grade-girls',
                'name' => '8th Grade Girls',
                'color' => '#15803d',
                'score' => 0,
            ],
        ],
    ];
}

function ensureScoreboardDataFile(): void
{
    $directory = dirname(SCOREBOARD_DATA_FILE);
    if (!is_dir($directory)) {
        mkdir($directory, 0775, true);
    }

    if (!is_file(SCOREBOARD_DATA_FILE)) {
        file_put_contents(SCOREBOARD_DATA_FILE, json_encode(scoreboardDefaultData(), JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . PHP_EOL, LOCK_EX);
    }
}

function readScoreboardData(): array
{
    ensureScoreboardDataFile();

    $raw = file_get_contents(SCOREBOARD_DATA_FILE);
    $decoded = json_decode($raw ?: '', true);

    return is_array($decoded) ? $decoded : scoreboardDefaultData();
}

function writeScoreboardData(callable $callback): array
{
    ensureScoreboardDataFile();

    $handle = fopen(SCOREBOARD_DATA_FILE, 'c+');
    if ($handle === false) {
        throw new RuntimeException('Unable to open the scoreboard data file.');
    }

    try {
        if (!flock($handle, LOCK_EX)) {
            throw new RuntimeException('Unable to lock the scoreboard data file.');
        }

        rewind($handle);
        $raw = stream_get_contents($handle);
        $current = json_decode($raw ?: '', true);
        if (!is_array($current)) {
            $current = scoreboardDefaultData();
        }

        $updated = $callback($current);
        $updated['updatedAt'] = gmdate('c');

        $encoded = json_encode($updated, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
        if ($encoded === false) {
            throw new RuntimeException('Unable to encode the scoreboard data.');
        }

        ftruncate($handle, 0);
        rewind($handle);
        fwrite($handle, $encoded . PHP_EOL);
        fflush($handle);
        flock($handle, LOCK_UN);

        return $updated;
    } finally {
        fclose($handle);
    }
}

function findTeamIndex(array $data, string $teamId): ?int
{
    foreach ($data['teams'] ?? [] as $index => $team) {
        if (($team['id'] ?? '') === $teamId) {
            return $index;
        }
    }

    return null;
}

function jsonResponse(array $payload, int $statusCode = 200): never
{
    http_response_code($statusCode);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($payload, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
    exit;
}

function readJsonRequestBody(): array
{
    $raw = file_get_contents('php://input');
    if ($raw === false || trim($raw) === '') {
        return [];
    }

    $decoded = json_decode($raw, true);
    return is_array($decoded) ? $decoded : [];
}
