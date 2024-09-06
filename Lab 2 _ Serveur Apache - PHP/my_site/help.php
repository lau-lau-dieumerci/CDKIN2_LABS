<?php
echo("Ceci est ma page help");
$message = "Une erreur s'est produite : Erreur simulée.";
error_log($message, 3, "/var/www/html/my_site/log.txt");
?>
