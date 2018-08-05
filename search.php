<?php

session_start();

require 'database2.php';

//collect
if(isset($_POST['search'])) {
	$searchq = $_POST['search'];
	$searchq = preg_replace("#[^0-9a-z]#i", "", $searchq);

	$query = mysql_query("SELECT * FROM parts WHERE company LIKE '%$searchq%' OR num LIKE '%$searchq%'") or die("Could not search");
	$count = mysql_num_rows($query);
	if($count == 0) {
		$output = 'There were no search results';
	}else{
		while($row = mysql_fetch_array($query)) {
			$com = $row['company'];
			$numm = $row['num'];
			$id = $row['id'];

			$output .='<div>'.$com.' '.$numm.' </div>';
		}
	}
}


?>

<!DOCTYPE html>
<html>
<head>
	<title>Search</title>
</head>
<body>

<form method = "_POST">
	
	<input type="text" name="search" action = "index.php" placeholder="Search for parts"/>
	<input type="submit" value=">>"/>
</form>

<?php print("$output");?>

</body>
</html>