<?php
require_once '../cntr/BingoTableManager.class.php';

// $strToken = "d98a9c506dbb34e4be98744ee507aa46a270e62b4212cad4d892110669541583";
$tableid = $_REQUEST['tableid'];
$obj = new BingoTableManager();
$aryTokenList = $obj->getPushUserTokenList($tableid);

$number = $_REQUEST['num'];

$ctx = stream_context_create();
stream_context_set_option($ctx , 'ssl' , 'local_cert' , 'pingo.pem');

$fp = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195' , $err , $errstr , 60 , STREAM_CLIENT_CONNECT , $ctx);

if(!$fp){
  echo "NG";
}

$body = array();
$body["aps"] = array('alert' => $number , 'badge' => '1' , 'sound' => 'default' , 'custom' => $number);
$payload = json_encode($body);
foreach ($aryTokenList as $key => $data) {
  echo $key."\n";
  // $msg= chr(0).pack("n",32).pack('H*',$strToken).pack("n",strlen($payload)).$payload;
  $msg= chr(0).pack("n",32).pack('H*',$data['token']).pack("n",strlen($payload)).$payload;
  fwrite($fp,$msg);
}
fclose($fp);


?>
