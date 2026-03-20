<?php
/**
 * Filename: youth/index.php
 * Revision: 1.0
 * Description: Public viewer page for CVC Youth Scoreboard.
 *              Displays live scores, auto-refreshes every 2 seconds.
 * Author: Jason Lamb (with help from Claude)
 * Created Date: 2026-03-19
 * Modified Date: 2026-03-19
 * Changelog
 * 1.0 Initial release for Youth scoreboard instance
 */
declare(strict_types=1);
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CVC Youth Scoreboard</title>
    <link rel="stylesheet" href="../public/styles.css" />
  </head>
  <body class="viewer-body" data-page-type="viewer">
    <div id="app"></div>
    <script src="../public/app.js" defer></script>
  </body>
</html>
