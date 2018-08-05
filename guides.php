<!DOCTYPE html>
<html>
<head>
  <title>Additional Guides</title>
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
      <h1 style="margin-bottom: -400px; color: #333; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">Additional Guides</h1>
      </div>

      <hr class="featurette-divider">

<div class="container" >

  <div class="row featurette">
    <div class="col-md-7" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
      <h2 class="active"><a class="featurette-heading" role="button" data-toggle="collapse" data-parent="#accordion" href="#1" id="accordion" style="align-content: center;" >Employee Handbooks</a></h2>
        <div id="1" class="panel-collapse collapse">
          <div class="lead" style="color: #333;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <li><a href="../Misc/SafetyHandbook.pdf" target="_blank" style="font-size: 24px;">Safety Handbook</a></li>
          </div>
        </div>
    </div>
  </div>
<p></p>

<div class="row featurette">
    <div class="col-md-7" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
      <h2 class="active"><a class="featurette-heading" role="button" data-toggle="collapse" data-parent="#accordion" href="#2" id="accordion" style="align-content: center;">Preventative Maintenance</a></h2>
        <div id="2" class="panel-collapse collapse">
          <div class="lead">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <ul>
              <li><a href="../Preventative Maintenance/Changing Lube Oil Filter.pdf" target="_blank" style="font-size: 24px;">Changing Lube Oil Filter</a></li>
              <li><a href="../Preventative Maintenance/EC 4th axis rotary table.pdf" target="_blank" style="font-size: 24px;">EC 4th Axis Rotary Table</a></li>
              <li><a href="../Preventative Maintenance/Haas Mills.pdf" target="_blank" style="font-size: 24px;">Haas Mills</a></li>
              <li><a href="../Preventative Maintenance/Haas replace gearbox oil.pdf" target="_blank" style="font-size: 24px;">Haas Replacing Gearbox Oil</a></li>
              <li><a href="../Preventative Maintenance/VF4 check gearbox oil.pdf" target="_blank" style="font-size: 24px;">VF4 Check Gearbox Oil</a></li>
              <li><a href="../Preventative Maintenance/VF4 check smtc oil.pdf" target="_blank" style="font-size: 24px;">VF4 Check SMTC Oil</a></li>
            </ul>
          </div>
        </div>
    </div>
  </div>
<p></p>

<div class="row featurette">
    <div class="col-md-7" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
      <h2 class="active"><a class="featurette-heading" role="button" data-toggle="collapse" data-parent="#accordion" href="#6" id="accordion" style="align-content: center;">Inspection Guides</a></h2>
        <div id="6" class="panel-collapse collapse">
          <div class="lead">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <ul>
              <li><a href="../Inspection Guides/Chamber Areas.pdf" target="_blank" style="font-size: 24px;">Chamber Areas</a></li>
              <li><a href="../Inspection Guides/Epoxy.pdf" target="_blank" style="font-size: 24px;">Epoxy</a></li>
              <li><a href="../Inspection Guides/Non-Critical Areas.pdf" target="_blank" style="font-size: 24px;">Non-Critical Areas</a></li>
              <li><a href="../Inspection Guides/ORings.pdf" target="_blank" style="font-size: 24px;">O-Rings</a></li>
              <li><a href="../Inspection Guides/Solder Joints.pdf" target="_blank" style="font-size: 24px;">Solder Joints</a></li>
            </ul>
          </div>
        </div>
    </div>
  </div>
<p></p>

<div class="row featurette">
    <div class="col-md-7" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
      <h2 class="active"><a class="featurette-heading" role="button" data-toggle="collapse" data-parent="#accordion" href="#7" id="accordion" style="align-content: center;">Assembly Instructions</a></h2>
        <div id="7" class="panel-collapse collapse">
          <div class="lead">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <ul>
              <li><a href="../Assembly Instructions/050114-000.pdf" target="_blank" style="font-size: 24px;">050114-000</a></li>
              <li><a href="../Assembly Instructions/1019353.pdf" target="_blank" style="font-size: 24px;">1019353</a></li>
              <li><a href="../Assembly Instructions/1045438.pdf" target="_blank" style="font-size: 24px;">1045438</a></li>
              <li><a href="../Assembly Instructions/1110050.pdf" target="_blank" style="font-size: 24px;">1110050</a></li>
              <li><a href="../Assembly Instructions/21440000-00-1 COPPER BAR.pdf" target="_blank" style="font-size: 24px;">21440000-00-1 COPPER BAR</a></li>
              <li><a href="../Assembly Instructions/21440000-00-10 COPPER BAR.pdf" target="_blank" style="font-size: 24px;">21440000-00-10 COPPER BAR</a></li>
              <li><a href="../Assembly Instructions/21460000-00-1 COPPER BAR.pdf" target="_blank" style="font-size: 24px;">21460000-00-1 COPPER BAR</a></li>
              <li><a href="../Assembly Instructions/2151777-00 GAS DEFFUSER.pdf" target="_blank" style="font-size: 24px;">2151777-00 GAS DEFFUSER</a></li>
              <li><a href="../Assembly Instructions/434244-222.pdf" target="_blank" style="font-size: 24px;">434244-222</a></li>
              <li><a href="../Assembly Instructions/777094-400.pdf" target="_blank" style="font-size: 24px;">777094-400</a></li>
              <li><a href="../Assembly Instructions/777096-664.pdf" target="_blank" style="font-size: 24px;">777096-664</a></li>
              <li><a href="../Assembly Instructions/777096-691.pdf" target="_blank" style="font-size: 24px;">777096-691</a></li>
              <li><a href="../Assembly Instructions/777098-049.pdf" target="_blank" style="font-size: 24px;">777098-049</a></li>
              <li><a href="../Assembly Instructions/777098-074.pdf" target="_blank" style="font-size: 24px;">777098-074</a></li>
              <li><a href="../Assembly Instructions/777099-791 IV POLE.pdf" target="_blank" style="font-size: 24px;">777099-791 IV POLE</a></li>
              <li><a href="../Assembly Instructions/AD88569.pdf" target="_blank" style="font-size: 24px;">AD88569</a></li>
              <li><a href="../Assembly Instructions/FB098096.pdf" target="_blank" style="font-size: 24px;">FB098096</a></li>
            </ul>
          </div>
        </div>
    </div>
  </div>
<p></p>

<div class="row featurette">
    <div class="col-md-7" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
      <h2 class="active"><a class="featurette-heading" role="button" data-toggle="collapse" data-parent="#accordion" href="#3" id="accordion" style="align-content: center;">RoHS Compliance</a></h2>
        <div id="3" class="panel-collapse collapse">
          <div class="lead" style="color: #333;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <ul>
                <li><a href="../Misc/RoHS List.htm" target="_blank" style="font-size: 24px;">RoHS List</a></li>
              </ul>
            <details>
              <summary style="font-size: 24px; text-indent: 24px; margin-top:10px; cursor:pointer;" class="collapse13">Copper & Brass</summary>
                <ul style="margin-left: 24px;" type="square">
                  <li><a href="../Copper&Brass/CentralSteel_Page8.pdf" target="_blank" style="font-size: 18px;">Central Steel</a></li>
                  <li><a href="../Copper&Brass/DorsetTubes.pdf" target="_blank" style="font-size: 18px;">Dorset Tubes</a></li>
                  <li><a href="../Copper&Brass/MuellerStreamline.pdf" target="_blank" style="font-size: 18px;">Mueller Streamline</a></li>
                  <li><a href="../Copper&Brass/OlympicMetals.pdf" target="_blank" style="font-size: 18px;">Olympic Metals</a></li>
                  <li><a href="../Copper&Brass/SequoisBrassCopper.pdf" target="_blank" style="font-size: 18px;">Sequois Brass & Copper</a></li>
                  <li><a href="../Copper&Brass/SmallTubeProducts.pdf" target="_blank" style="font-size: 18px;">Small Tube Products</a></li>
                </ul>
            </details>

            <details>
              <summary style="font-size: 24px; text-indent: 24px; margin-top:10px; cursor:pointer;" class="collapse14">Stainless Steel</summary>
                <ul style="margin-left: 24px;" type="square">
                  <li><a href="../StainlessSteel/EagleAlloys.pdf" target="_blank" style="font-size: 18px;">Eagle Alloys</a></li>
                  <li><a href="../StainlessSteel/EMJ.pdf" target="_blank" style="font-size: 18px;">EMJ</a></li>
                  <li><a href="../StainlessSteel/MarmonKeystone.pdf" target="_blank" style="font-size: 18px;">Marmon Keystone</a></li>
                  <li><a href="../StainlessSteel/Nordex.pdf" target="_blank" style="font-size: 18px;">Nordex</a></li>
                  <li><a href="../StainlessSteel/Ryerson.JPG" target="_blank" style="font-size: 18px;">Ryerson</a></li>
                  <li><a href="../StainlessSteel/SamuelSon&Co.pdf" target="_blank" style="font-size: 18px;">Samuel Son & Co.</a></li>
                  <li><a href="../StainlessSteel/SliceOfStainless.jpg" target="_blank" style="font-size: 18px;">Slice Of Stainless</a></li>
                  <li><a href="../StainlessSteel/StockDriveProducts.pdf" target="_blank" style="font-size: 18px;">Stock Drive Products</a></li>
                  <li><a href="../StainlessSteel/TubeServiceCo.pdf" target="_blank" style="font-size: 18px;">Tube Service Co.</a></li>
                  <li><a href="../StainlessSteel/WMBerg.pdf" target="_blank" style="font-size: 18px;">WM Berg</a></li>
                </ul>
            </details>

            <details>
              <summary style="font-size: 24px; text-indent: 24px; margin-top:10px; cursor:pointer;" class="collapse15">Epoxies</summary>
                <ul style="margin-left: 24px;" type="square">
                  <li><a href="../Epoxies/DevCon_10710_AluminumF2Epoxy.pdf" target="_blank" style="font-size: 18px;">DevCon 10710 Aluminum F2 Epoxy</a></li>
                  <li><a href="../Epoxies/DowCorning_1-4173_TCThermallyConductiveAdhesiveGray.pdf" target="_blank" style="font-size: 18px;">DowCorning 1-4173 TC Thermally Conductive Epoxy Gray</a></li>
                  <li><a href="../Epoxies/DowCorning_1-4173_TCThermallyConductiveAdhesiveGray2.pdf" target="_blank" style="font-size: 18px;">DowCorning 1-4173 TC Thermally Conductive Epoxy Gray 2</a></li>
                  <li><a href="../Epoxies/Duralco_132_AluminumFilledEpoxy.pdf" target="_blank" style="font-size: 18px;">Duralco 132 Aluminum Filled Epoxy</a></li>
                </ul>
            </details>

            <details>
              <summary style="font-size: 24px; text-indent: 24px; margin-top:10px; cursor:pointer;" class="collapse16">Helicoils</summary>
                <ul style="margin-left: 24px;" type="square">
                  <li><a href="../Helicoils/AerospaceComputerSupplies_Helicoils.JPG" target="_blank" style="font-size: 18px;">Aerospace Computer Supplies</a></li>
                  <li><a href="../Helicoils/Helicoil_1191-3CN190.JPG" target="_blank" style="font-size: 18px;">Helicoil 1191-3CN190</a></li>
                </ul>
            </details>

            <details>
              <summary style="font-size: 24px; text-indent: 24px; margin-top:10px; cursor:pointer;" class="collapse17">Loctite</summary>
                <ul style="margin-left: 24px;" type="square">
                  <li><a href="../Loctite/Loctite_242.pdf" target="_blank" style="font-size: 18px;">Loctite 242</a></li>
                  <li><a href="../Loctite/Loctite_271.pdf" target="_blank" style="font-size: 18px;">Loctite 271</a></li>
                  <li><a href="../Loctite/Loctite_290.pdf" target="_blank" style="font-size: 18px;">Loctite 290</a></li>
                </ul>
            </details>

            <details>
              <summary style="font-size: 24px; text-indent: 24px; margin-top:10px; cursor:pointer;" class="collapse18">Solders</summary>
                <ul style="margin-left: 24px;" type="square">
                  <li><a href="../Solders/Bridgit_ASTMB32.pdf" target="_blank" style="font-size: 18px;">Harris Products ASTMB32</a></li>
                  <li><a href="../Solders/Bridgit_LeadFree.pdf" target="_blank" style="font-size: 18px;">Harris Products Lead Free</a></li>
                  <li><a href="../Solders/RadnorByHarris_PN64001770.pdf" target="_blank" style="font-size: 18px;">Harris Products PN64001770</a></li>
                  <li><a href="../Solders/KappZapp.pdf" target="_blank" style="font-size: 18px;">Kapp Zapp</a></li>
                  <li><a href="../Solders/StayBrite8.pdf" target="_blank" style="font-size: 18px;">Stay Brite 8</a></li>
                </ul>
            </details>

            <details>
              <summary style="font-size: 24px; text-indent: 24px; margin-top:10px; cursor:pointer;" class="collapse19">Plastics</summary>
                <ul style="margin-left: 24px;" type="square">
                  <li><a href="../Plastics/Boedecker.pdf" target="_blank" style="font-size: 18px;">Boedecker</a></li>
                  <li><a href="../Plastics/ColoradoPlastics.pdf" target="_blank" style="font-size: 18px;">Colorado Plastics</a></li>
                  <li><a href="../Plastics/Curbell.JPG" target="_blank" style="font-size: 18px;">Curbell</a></li>
                  <li><a href="../Plastics/Laird.pdf" target="_blank" style="font-size: 18px;">Laird</a></li>
                  <li><a href="../Plastics/SabicInnovativePlastics.pdf" download="Sabic_Innovative_Plastics" style="font-size: 18px;">Sabic Innovative Plastics</a></li>
                </ul>
            </details>

            <details>
              <summary style="font-size: 24px; text-indent: 24px; margin-top:10px; cursor:pointer;" class="collapse20">Misc</summary>
                <ul style="margin-left: 24px;" type="square">
                  <li><a href="../Misc/Harris_StayClean_Flux.pdf" target="_blank" style="font-size: 18px;">Harris Stay Clean Flux</a></li>
                  <li><a href="../Misc/Kato.pdf" target="_blank" style="font-size: 18px;">Kato</a></li>
                  <li><a href="../Misc/Swagelok_Fittings.pdf" target="_blank" style="font-size: 18px;">Swagelok Fittings</a></li>
                </ul>
            </details>
            <br>
          </div>
        </div>
    </div>
  </div>
<p></p>

<div class="row featurette">
    <div class="col-md-7" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
      <h2 class="active"><a class="featurette-heading" role="button" data-toggle="collapse" data-parent="#accordion" href="#4" id="accordion" style="align-content: center;">Egress Fire Routes</a></h2>
        <div id="4" class="panel-collapse collapse">
          <div class="lead">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <ul>
              <li><a href="../Egress/Fire Routes - Landscape.pdf" target="_blank" style="font-size: 24px;">Fire Routes - Landscape</a></li>
              <li><a href="../Egress/Fire Routes - Portrait.pdf" target="_blank" style="font-size: 24px;">Fire Routes - Portrait</a></li>
            </ul>
          </div>
        </div>
    </div>
  </div>
<p></p>

<div class="row featurette">
    <div class="col-md-7" style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">
      <h2 class="active"><a class="featurette-heading" role="button" data-toggle="collapse" data-parent="#accordion" href="#5" id="accordion" style="align-content: center;">Miscellaneous</a></h2>
        <div id="5" class="panel-collapse collapse">
          <div class="lead">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <ul>
              <li><a href="../Misc/Washing Classifications.pdf" target="_blank" style="font-size: 24px;">Washing Classifications</a></li>
              <li><a href="../Misc/Reference List.htm" target="_blank" style="font-size: 24px;">Reference List</a></li>
              <li><a href="../Misc/TimeStudiesApex.htm" target="_blank" style="font-size: 24px;">Time Studies - Apex</a></li>
              <li><a href="../Misc/PowersticksAPEXLog.htm" target="_blank" style="font-size: 24px;">Powersticks & APEX Plates Log Sheet</a></li>
            </ul>
            <details>
              <summary style="font-size: 24px; text-indent: 24px; margin-top:10px; cursor:pointer;" class="collapse20">Powersticks</summary>
                <ul style="margin-left: 24px;" type="square">
                  <li><a href="../Powersticks/Powerstick shipments 2017.htm" target="_blank" style="font-size: 18px;">Powerstick Shipments 2017</a></li>
                  <li><a href="../Powersticks/Time Studies - Powersticks.htm" target="_blank" style="font-size: 18px;">Time Studies - Powersticks</a></li>
                </ul>
            </details>
          </div>
        </div>
    </div>
  </div>
<p></p>


</div>

<hr />
      <footer style="background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif; margin-left: 20px; margin-right: 20px; margin-top: 100px;">
        <p class="pull-right" style="margin-right: 20px;"><a href="#"></br>Back to top&nbsp;&nbsp;&nbsp;</a></p>
        <p style="color: #333; margin-left: 20px;"></br>&copy; 2017 EMP, Inc.</p>
        </br>
      </footer>

</body>
</html>




