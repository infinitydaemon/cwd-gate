<?php
$serverName = filter_input(INPUT_SERVER, 'SERVER_NAME', FILTER_SANITIZE_STRING);
$serverName = preg_replace('/^\[(.*)\]$/', '${1}', $serverName);

$landPage = "../landing.php";

$authorizedHosts = [ "localhost" ];
if (!empty($_SERVER["FQDN"])) {
    array_push($authorizedHosts, $serverName);
} else if (!empty($_SERVER["VIRTUAL_HOST"])) {
    array_push($authorizedHosts, $_SERVER["VIRTUAL_HOST"]);
}

if ($serverName === "pi.hole" || (!empty($_SERVER["VIRTUAL_HOST"]) && $serverName === $_SERVER["VIRTUAL_HOST"])) {
    header("Location: /admin");
    exit();
} elseif (filter_var($serverName, FILTER_VALIDATE_IP) || in_array($serverName, $authorizedHosts)) {
    unset($authorizedHosts);
    if (is_file(getcwd()."/$landPage")) {
        include $landPage;
        exit();
    }
}
    // If $landPage file was not present, Set Splash Page output
    $splashPage = <<<EOT
    <!doctype html>
    <html lang='en'>
        <head>
            <meta charset='utf-8'>
            <meta name='viewport' content='width=device-width, initial-scale=1'>
            <title>● $serverName</title>
            <link rel='shortcut icon' href='/admin/img/favicons/favicon.ico' type='image/x-icon'>
            <style>
                html, body { height: 100% }
                body { margin: 0; font: 13pt "Source Sans Pro", "Helvetica Neue", Helvetica, Arial, sans-serif; }
                body { background: #222; color: rgba(255, 255, 255, 0.7); text-align: center; }
                p { margin: 0; }
                a { color: #3c8dbc; text-decoration: none; }
                a:hover { color: #72afda; text-decoration: underline; }
                #splashpage { display: flex; align-items: center; justify-content: center; }
                #splashpage img { margin: 5px; width: 256px; }
                #splashpage b { color: inherit; }
            </style>
        </head>
        <body id='splashpage'>
            <div>
            <img src='/admin/img/logo.svg' alt='Pi-hole logo' width='256' height='377'>
            <br>
            <p>Pi-<strong>hole</strong>: Your black hole for Internet advertisements</p>
            <a href='/admin'>Did you mean to go to the admin panel?</a>
            </div>
        </body>
    </html>
EOT;
    exit($splashPage);
}

header("HTTP/1.1 404 Not Found");
exit();
?>
