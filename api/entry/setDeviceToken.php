<?php

/**
 * アプリからユーザ情報を受け取ります
 * token : デバイストークン
 * fbId  : facebook の ID
 * fbName: facebook の ユーザ名(日本語もあるかも・・・？)
 */


$token = $_POST['token'];
$fbId = $_POST['fbId'];
$fbName = $_POST['fbName'];
error_log($token . $fbId . $fbName);


?>
