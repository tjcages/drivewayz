<!DOCTYPE html>
<html>
<head>
  <title>About Us</title>
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
                <li><a asp-area="" asp-controller="Home" asp-action="about.php">About</a></li>
                <li><a asp-area="" asp-controller="Home" asp-action="contact.php" href="contact.php">Contact</a></li>
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


<div class="partcontainer" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499;">
    <br>
      <h1 style="margin-bottom: -400px; color: #333; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">About Us</h1>

      <hr class="featurette-divider">
      <div class="container vertical-center" style="color: #333; margin-top: -150px; margin-bottom: -150px;">
       <div class="lead">Electro-Mechanical Products, Inc. (EMP) is a leading manufacturer of precision machined components, thermal management solutions, and mechanical and electrical subassemblies used by technology-driven industries worldwide. For more than 40 years, we have upheld an impeccable safety record while custom-designing innovative manufacturing solutions for the semiconductor, medical, laser, aerospace, commercial and high-tech business sectors.
                  <br><br>With a dedicated team of engineers on staff, no design is too complex and no project too tedious. We have a strong affinity for taking on challenging-to-produce designs, and we pride ourselves on delivering quality components that make a difference, giving our customers the confidence and value they can depend on.
                  <br><br>In addition to our technical expertise, safety is another industry differentiator for EMP. In the 2016 NCCI (National Council on Compensation Insurance) rating, EMP earned a 0.77 EMOD (Experience Modification Rate) and has consistently ranked well below the 1.0 industry average for the past 10 years. The EMOD is a rating factor used in the insurance industry to compare employers’ historical claims and payroll data to their peers in similar business operations.
                  <br><br>EMP is committed to safely manufacture your product at a competitive cost, with exceptional quality and deliver it on-time to give you a sustained competitive advantage in today’s global economy.
            </div>
            </div>
            <div class="image" style="flex: wrap;">
          <img class="featurette-image img-responsive center-block" vspace="25" style= "background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; width: 800px; height: 500px; display: block; margin-bottom: 20px;" src="http://electromechanicalproducts.com/wp-content/uploads/2016/03/9.jpg" alt="Generic placeholder image"></br>
          </br>
          </br>
          </br>
          </div>
        </div>
        </div>


                    <hr />
      <footer style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif; margin-left: 20px; margin-right: 20px;">
        <p class="pull-right" style="margin-right: 20px;"><a href="#"></br>Back to top&nbsp;&nbsp;&nbsp;</a></p>
        <p style="color: #333; margin-left: 20px;"></br>&copy; 2017 EMP, Inc.</p>
        </br>
      </footer>


</body>
</html>

