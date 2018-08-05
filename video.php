<!DOCTYPE html>
<html>
<head>
  <title>Video Tutorials</title>
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
                  <li><a href="index.html" class="mylink">Procedures</a></li>
                  <li><a href="guides.php">Additional Guides</a></li>
                  <li><a href="video.php">Video Tutorials</a></li>
                  <li><a href="parts.php">Part Index</a></li>
                </ul>
              </li>
              </ul>
            </div>
          </div>
        </nav>


<script type="text/javascript">


var TRange=null;

function findString (str) {
 if (parseInt(navigator.appVersion)<4) return;
 var strFound;
 if (window.find) {

  // CODE FOR BROWSERS THAT SUPPORT window.find

  strFound=self.find(str);
  if (!strFound) {
   strFound=self.find(str,0,1);
   while (self.find(str,0,1)) continue;
  }
 }
 else if (navigator.appName.indexOf("Microsoft")!=-1) {

  // EXPLORER-SPECIFIC CODE

  if (TRange!=null) {
   TRange.collapse(false);
   strFound=TRange.findText(str);
   if (strFound) TRange.select();
  }
  if (TRange==null || strFound==0) {
   TRange=self.document.body.createTextRange();
   strFound=TRange.findText(str);
   if (strFound) TRange.select();
  }
 }
 else if (navigator.appName=="Opera") {
  alert ("Opera browsers not supported, sorry...")
  return;
 }
 if (!strFound) alert ("String '"+str+"' not found!")
 return;

}</script>


<div class="partcontainer">
    <br>
      <h1 style="margin-bottom: -400px; color: #333; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">Video Tutorials</h1>
      </div>


    <div class="container" style="color: #333;">
      <hr class="featurette-divider">

      <div class="row featurette" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
        <div class="col-md-7">
          <h2 class="active"><a class="featurette-heading">Properly Mixing Epoxy</a></h2>
            <p class="lead">Mixing the resin and activator is another important step in the process for creating a quality epoxy layer. Refer to the epoxy charts when working with activator and resin to know how much to mix. The proper ratio is vital in ensuring a chemically strong bond within the polymer.</br></p>
    </div>
        <div class="col-md-5" style="padding-top: 8px; padding-bottom: 8px;">
          <video width="420" height="315" controls>
            <source src="../Videos/IMG_4317.MOV" type="video/mp4">
          </video>
        </div>
      </div>

      <hr class="featurette-divider">

      <div class="row featurette" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
        <div class="col-md-7">
          <h2 class="active"><a class="featurette-heading">Straighten Cold Plates</a></h2>
            <p class="lead">EMP ensures that all of its products are specifically to design standards. This allows for the greatest amount of heat transfer between surfaces and the most efficient thermal conducting plate. Straightening these plates is a very important process that involves use of the presses.</br></p>
    </div>
        <div class="col-md-5" style="padding-top: 8px; padding-bottom: 8px;">
          <video width="420" height="315" controls>
            <source src="../Videos/IMG_4320.MOV" type="video/mp4">
          </video>
        </div>
      </div>

      <hr class="featurette-divider">

      <div class="row featurette" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
        <div class="col-md-7">
          <h2 class="active"><a class="featurette-heading">Harbor Press For Flattening Copper Tubes</a></h2>
            <p class="lead">The hydraulic press has many uses, mainly to flatten tubes and plates or press tubes down into the tube track. This machine can be extremely dangerous so it is important to keep all hands and other body parts out from under the piston. Make sure to also only use fixtures that are not brittle as they may shatter under these extreme pressures. Using the hydraulic press to flatten copper tubes requires specific fixtures to obtain the required "D" shape of the tube.</br></p>
    </div>
        <div class="col-md-5" style="padding-top: 8px; padding-bottom: 8px;">
          <video width="420" height="315" controls>
            <source src="../Videos/IMG_4310.MOV.mov" type="video/mp4">
          </video>
        </div>
      </div>

            <hr class="featurette-divider">

      <div class="row featurette" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
        <div class="col-md-7">
          <h2 class="active"><a class="featurette-heading">Pneumatic Press For Tube Install</a></h2>
            <p class="lead">The hydraulic press has many uses, mainly to flatten tubes and plates or press tubes down into the tube track. This machine can be extremely dangerous so it is important to keep all hands and other body parts out from under the piston. The two buttons must simultaneously be pressed for the piston to fire. Using the hydraulic press for tube install is more precise and requires more hits. Use the bottom tray to guide the part around the track until the piston is properly lined up.</br></p>
    </div>
        <div class="col-md-5" style="padding-top: 8px; padding-bottom: 8px;">
          <video width="420" height="315" controls>
            <source src="../Videos/IMG_4321.MOV" type="video/mp4">
          </video>
        </div>
      </div>

            <hr class="featurette-divider">

      <div class="row featurette" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
        <div class="col-md-7">
          <h2 class="active"><a class="featurette-heading">Aesthetic Void Epoxy</a></h2>
            <p class="lead">Void epoxy is the process of dremmeling away pockets of epoxy to then be filled back in uniformly. This process is purely aesthetic, but makes a large difference when customers have such specific requests.</br></p>
    </div>
        <div class="col-md-5" style="padding-top: 8px; padding-bottom: 8px;">
          <video width="420" height="315" controls>
            <source src="../Videos/IMG_4319.MOV" type="video/mp4">
          </video>
        </div>
      </div>

            <hr class="featurette-divider">


      <div class="row featurette" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
        <div class="col-md-7">
          <h2 class="active"><a class="featurette-heading">Coolant Management (Reading & Measure)</a></h2>
            <p class="lead">CLAYTON</br></p>
    </div>
        <div class="col-md-5" style="padding-top: 8px; padding-bottom: 8px;">
          <video width="420" height="315" controls>
            <source src="../Videos/Coolant.mp4" type="video/mp4">
          </video>
        </div>
      </div>


    </div>
<hr />
      <footer style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif; margin-left: 20px; margin-right: 20px; margin-top: 100px;">
        <p class="pull-right" style="margin-right: 20px;"><a href="#"></br>Back to top&nbsp;&nbsp;&nbsp;</a></p>
        <p style="color: #333; margin-left: 20px;"></br>&copy; 2017 EMP, Inc.</p>
        </br>
      </footer>

</body>
</html>

