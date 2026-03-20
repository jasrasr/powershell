<?php
/**
 * Filename: enter-scores.php
 * Revision: 1.0
 * Description: Admin score entry page for CVC Youth Scoreboard (root instance).
 *              Allows authorized users to update, reset, and rename team scores and title.
 * Author: Jason Lamb (with help from Claude)
 * Created Date: 2026-03-19
 * Modified Date: 2026-03-19
 * Changelog
 * 1.0 Initial release; admin page split from index.php
 */
declare(strict_types=1);
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CVC Youth Scoreboard Admin</title>
    <link rel="stylesheet" href="./public/styles.css" />
  </head>
  <body data-page-type="admin">
    <div id="app"></div>
    <script src="./public/app.js" defer></script>
  </body>
</html>
