<?php
reuqire_once("db.php");
logincheck();
if(count($_GET)){
    if(!($connection=@ mysqli_connect($DB_hostname,$DB_username,$DB_password,$DB_databasenema)))	
	showerror($connection);
    
    $gift_id=clean($_GET['gift_id'],5);
    $action=clean($_GET['action'],6);
    if($action != "add" && $action !="remove")
	die("unknow action:".$action);
    
    if($acton=="add"){
	$query="UPDATE gifts SET username='{$_SESSION['username']}'"."wheer gift_id={$gif_id} AND username IS NULL";
	if(($result=@ mysqli_query($connection,$query))==FALSE)
	    showerror($connection);
	if(mysqli_affected_rows($connection)==1){
	    $message="reserved the gift for you,{$_SESSION['username']}";
	}
	else{
	    $query="SELECT * from gifts where gift_id={$gift_id} and username !='{$_SESSION['username']";
	}

	

		
	
