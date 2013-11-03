<?php
/*
 * 管理者用の番号を生成
 */
function makeMasterNumber() {
    $aryList = range(1, 75);
    shuffle($aryList);

    return $aryList;
}

/*
 * ユーザ用の番号を生成
 */
function makeUserNumber() {
    $result = array();
    for ($i=0; $i<5; $i++) {
        $aryRow = array();
        $intAddNum = $i * 15;
        $aryList = range(1 + $intAddNum, 15 + $intAddNum);

        shuffle($aryList);
        for ($j=0; $j<5; $j++) {
            $aryRow[] = $aryList[$j];
        }

        $result[] = $aryRow;
    }

    return $result;
}
?>
