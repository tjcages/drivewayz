<?php

$resourse = opendir('MASTER PRINTS');

if(!empty($_POST['search'])):

$searchq = $_POST['search'];

$i = 0;
$entry = array(readdir($resourse));

while(($entry = readdir($resourse)) !== FALSE){
  $i = $i + 1;
  if($entry != '.' && $entry != '..'){
    $keywords = preg_split("/[\s.]+/", $entry);
    $partnum[$i] = $keywords[0];
    $rev[$i] = $keywords[2];
    $link[$i] = $entry;
    $date[$i] = $keywords[3];

      if ($date[$i] == 'PDF' || $date[$i] == 'pdf' || $date[$i] == '(1)' || $date[$i] == '(2)' || $date[$i] == '(3)' || $date[$i] == '(4)') {
        $date[$i] = $keywords[2];
        if (ctype_alpha($date[$i])) {
          $date[$i] = $keywords[4];
        } else {}
     } else {}
    }
  }

// $dateorder = str_replace($date('-', '/'),'', $dateorder);
// arsort($dateorder);

// while(($entry = readdir($resourse)) !== FALSE){
//   $l = $l + 1;
//   if($fpartnum[$l] != $fpartnum[($l+1)]) {
//     if($dateorder[$l] > $dateorder[($l+1)]) {
//       unset($entry[($l+1)]);
//     } else if($dateorder[$l] < $dateorder[($l+1)]) {
//       unset($entry[$l]);
//     } else {}
//   }
// }


$date = str_replace(array(':','/','-'),'/', $date);
$orderByDate = $my2 = $date;
foreach($data as $key=>$row)
{
    $my2 = explode('/',$row[1]);
    $my_date2 = $my2[0].'/'.$my2[1].'/'.$my2[2];        
    $orderByDate[$key] = strtotime($my_date2);  
}    
array_multisort($orderByDate, SORT_DESC, $data);



$fpartnum = array_reverse($partnum);
$frev = array_reverse($rev);
$fdate = array_reverse($date);
$flink = array_reverse($link);

endif;

?>


<!DOCTYPE html>
<html>
<head>
  <title>Part Index</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
  <link rel="stylesheet" type="text/css" href="assets/css/style.css">
  <link href='http://fonts.googleapis.com/css?family=Comfortaa' rel='stylesheet' type='text/css'>
   <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>@ViewData["Title"] - EMP</title>

    <environment names="Development">
        <link href="~/wwwroot/css/carousel.css" rel="stylesheet" />
        <link rel="stylesheet" href="~/lib/bootstrap/dist/css/bootstrap.css" />
    
        <link rel="stylesheet" href="~/css/site.css" />
    </environment>
    <environment names="Staging,Production">
        <link rel="stylesheet" href="https://ajax.aspnetcdn.com/ajax/bootstrap/3.3.7/css/bootstrap.min.css"
              asp-fallback-href="~/lib/bootstrap/dist/css/bootstrap.min.css"
              asp-fallback-test-class="sr-only" asp-fallback-test-property="position" asp-fallback-test-value="absolute" />
              <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet" />
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>

    </environment>

<script type="text/javascript">

//[CDATA[
var pre = onload;
onload = function(){
if(pre)pre();
var doc = document, bod = doc.body;
function E(e){
  return doc.getElementById(e);
}
E('html_id').onkeydown = function(ev){
  var e = ev || event;
  if(e.keyCode === 13){
    // cntrl+f was pressed - run code showing Element and Element.focus() if needed
  }
}
}
//]]>

</script>

</head>

<body style="background-color: #F1F1F1;">

<?php if(!empty($message)): ?>
    <p><?= $message ?></p>
  <?php endif; ?>

    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
              <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
              </button>
              <a asp-area="" asp-controller="Home" href="/" class="navbar-brand">EMP</a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
              <ul class="nav navbar-nav">
                <li><a asp-area="" asp-controller="Home" href="/">Home</a></li>
                <li><a asp-area="" asp-controller="Home" asp-action="about.php" href="about.php">About</a></li>
                <li><a asp-area="" asp-controller="Home" asp-action="Contact">Contact</a></li>
                <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Content<span class="caret"></span></a>
                <ul class="dropdown-menu">
                  <li><a href="index.html">Procedures</a></li>
                  <li><a href="guides.php">Additional Guides</a></li>
                  <li><a href="video.php">Video Tutorials</a></li>
                  <li><a href="parts.php">Part Index</a></li>
                </ul>
              </li>
              </ul>
              <form action="parts.php" method="post" class="navbar-form navbar-right" method="_POST">
                <input type="text" name="search" placeholder="Search parts.." class="form-control" onkeydown = "if (event.keyCode == 13)
                        document.getElementById('btnSearch').click()" style="position: 100px; margin-right: 20px; margin-top: 2px; margin-bottom: -2px; margin-left: 10px;">
                <input type="submit" class="offscreen" onclick="myFunction()" id = "btnSearch">
              </form>
            </div>
          </div>
        </nav>

<script type="text/javascript">

function myFunction() {
    var x = document.getElementById('myDIV');
    if (x.style.display === 'none') {
        x.style.display = 'block';
    } else {
        x.style.display = 'none';
    }
}

</script>

<div class="partcontainer">
    <br>
      <h1 style="margin-bottom: -400px; color: #333; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">Part Index:</h1>
      </div>


<div class="container">
    <div style="display: flex; justify-content: space-between;">
      <h2 class="active" style="color: #333; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
        Part Number
      </h2>
      <h2 class="active" style="color: #333; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Revision
      </h2>
      <h2 class="active" style="color: #333; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
        Date of Print
      </h2>
    </div>
  </div>
  <hr class="featurette-divider">
</div>

<?php 
$j = -1;
while($j < $i) {
  $j = $j + 1;
  if(strncmp($searchq, $fpartnum[$j], strlen($searchq)) == 0){
?>

<div class="container" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
    <div style="display: flex; justify-content: space-between;">
      <h2 class="active" style="margin-left: 20px;"><a href="../MASTER PRINTS/<?php echo $flink[$j]; ?>" target="_blank">
        <?php 
    echo $fpartnum[$j];
      ?>
      </a></h2>
      <h2 class="active"><a href="../MASTER PRINTS/<?php echo $flink[$j]; ?>" target="_blank">
        <?php 
    echo "REV&nbsp;".$frev[$j];
        ?>
      </a></h2>
      <h2 class="active" style="margin-right: 20px;"><a href="../MASTER PRINTS/<?php echo $flink[$j]; ?>" target="_blank">
        <?php 
    echo $fdate[$j];
    echo $entry;
        ?>
      </a></h2>
    </div>
  </div>
  <?php if($fpartnum[$j] != $fpartnum[($j+1)]) { 
    unset($fpartnum[$j]);

    ?>
    <p></p>
  <?php } else {} ?>
</div>

<?php
}else{
}
}
?>

<hr />
      <footer style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif; margin-left: 20px; margin-right: 20px; margin-top: 100px;">
        <p class="pull-right" style="margin-right: 20px;"><a href="#"></br>Back to top&nbsp;&nbsp;&nbsp;</a></p>
        <p style="color: #333; margin-left: 20px;"></br>&copy; 2017 EMP, Inc.</p>
        </br>
      </footer>


</body>
</html>


