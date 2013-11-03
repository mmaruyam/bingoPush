<?php
/*
 * 管理者用の番号を返すAPI
 */
require_once '../util/makeCardNumber.php';
$aryList = makeMasterNumber();
sleep(2);
print_r(json_encode($aryList));
?>
