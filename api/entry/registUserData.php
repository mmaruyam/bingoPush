<?php
require_once '/var/www/html/bingo/api/cntr/UserManager.class.php';

$aryParams = array();
$aryParamKeys = array('id', 'name', 'token');
foreach ($aryParamKeys as $key) {
    if (empty($_REQUEST[$key])) {
        continue;
    }

    $aryParams[$key] = $_REQUEST[$key];
}

$UserManager = new UserManager();
$result = $UserManager->registUserInfo(
     $aryParams['id'], 
     $aryParams['name'], 
     $aryParams['token']);

/*
$result = $UserManager->registUserInfo(
    10, 
    'mma2ruyam', 
    'mmaruyamToken');
*/
echo $result;
?>
