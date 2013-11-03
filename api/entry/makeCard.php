<?php

$bingo = array();
for($j=0;$j<5;$j++){
  $ary = array();

  for($i=0;$i<15;$i++){
    $ary[$i] = $i+1;
  }

  $result = array();
  for($i=0;$i<5;$i++){

    $randNum = rand(0,100)%10;

    $result[] = $ary[$randNum] + ($j*15);
    unset($ary[$randNum]);

    $tmp = array();
    foreach($ary as $num){
      $tmp[] = $num;
    }

    $ary = $tmp;
  
  }
  $bingo[$j][] = $result;
}

//表示用
/*
for($i=0;$i<5;$i++){
  for($j=0;$j<5;$j++){
    echo $bingo[$j][0][$i]; 
    echo " | ";
  }
  echo "\n";
}
*/

//json
$json = "{";
for($i=0;$i<5;$i++){
  $json .= '"' .  $i . '":[';
  for($j=0;$j<5;$j++){
    $json .= $bingo[$i][0][$j];
    if($j != 4){
      $json .= ",";
    }
  }
      $json .= "]";
      if($i != 4){
        $json .= ",";
      }
}
$json .= "}";

echo $json . "\n";

?>
