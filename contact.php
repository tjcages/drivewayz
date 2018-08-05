<!DOCTYPE html>
<html>
<head>
  <title>Contact EMP</title>
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
                <li><a asp-area="" asp-controller="Home" asp-action="Contact" href="#">Contact</a></li>
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


<div class="partcontainer" style="background-color: #F1F1F1; box-shadow: 0.75px 0.75px 0.75px #959499;">
    <br>
      <h1 style="margin-bottom: -400px; color: #333; font-family: 'Roboto-MediumItalic', Helvetica, Arial, sans-serif;">Contact EMP</h1>

      <hr class="featurette-divider">

<div class="container" style="color: #333; background-color: #FFF; box-shadow: 0.75px 0.75px 0.75px #959499;">
<div class="row justify-content-center">
<div class="col-6">
<div class="lead" style="margin-left: 60px; margin-right: 60px;"></br>Thank you for your interest in EMP. Please fill out the information below and one of our customer service team members will be in touch.</br></br></div></div>

                <div class="gf_browser_chrome gform_wrapper" id="gform_wrapper_1"><form method="post" enctype="multipart/form-data" id="gform_1" action="/contact.php">
                        <div class="gform_body"><ul id="gform_fields_1" class="gform_fields top_label form_sublabel_below description_above"><li id="field_1_1" class="gfield gfield_contains_required field_sublabel_below field_description_above gfield_visibility_visible"><label class="gfield_label gfield_label_before_complex" for="input_1_1_3">Name<span class="gfield_required">*</span></label><div class="ginput_complex ginput_container no_prefix has_first_name no_middle_name has_last_name no_suffix gf_name_has_2 ginput_container_name gfield_trigger_change" id="input_1_1">
                            
                            <span id="input_1_1_3_container" class="name_first">
                                                    <input type="text" name="input_1.3" id="input_1_1_3" value="" aria-label="First name" tabindex="3" aria-required="true" aria-invalid="false">
                                                    <label for="input_1_1_3">First</label>
                                                </span>
                            
                            <span id="input_1_1_6_container" class="name_last">
                                                    <input type="text" name="input_1.6" id="input_1_1_6" value="" aria-label="Last name" tabindex="5" aria-required="true" aria-invalid="false">
                                                    <label for="input_1_1_6">Last</label>
                                                </span>
                            
                        </div></li><li id="field_1_2" class="gfield gf_left_half gfield_contains_required field_sublabel_below field_description_above gfield_visibility_visible"><label class="gfield_label" for="input_1_2">Phone<span class="gfield_required">*</span></label><div class="ginput_container ginput_container_phone"><input name="input_2" id="input_1_2" type="text" value="" class="medium" tabindex="7" aria-required="true" aria-invalid="false"></div></li><li id="field_1_3" class="gfield gf_right_half gfield_contains_required field_sublabel_below field_description_above gfield_visibility_visible"><label class="gfield_label" for="input_1_3">Email<span class="gfield_required">*</span></label><div class="ginput_container ginput_container_email">
                            <input name="input_3" id="input_1_3" type="text" value="" class="medium" tabindex="8" aria-required="true" aria-invalid="false">
                        </div></li><li id="field_1_4" class="gfield field_sublabel_below field_description_above gfield_visibility_visible"><label class="gfield_label" for="input_1_4">Comment</label><div class="ginput_container ginput_container_textarea"><textarea name="input_4" id="input_1_4" class="textarea medium" tabindex="9" aria-invalid="false" rows="10" cols="50"></textarea></div></li>
                            </ul></div>


        <div class="gform_footer top_label" style="padding-left: 100px"> <input type="submit" id="gform_submit_button_1" class="gform_button button" value="Send to EMP" tabindex="38" onclick="if(window[&quot;gf_submitting_1&quot;]){return false;}  window[&quot;gf_submitting_1&quot;]=true;  " onkeypress="if( event.keyCode == 13 ){ if(window[&quot;gf_submitting_1&quot;]){return false;} window[&quot;gf_submitting_1&quot;]=true;  jQuery(&quot;#gform_1&quot;).trigger(&quot;submit&quot;,[true]); }"> 
            <input type="hidden" class="gform_hidden" name="is_submit_1" value="1">
            <input type="hidden" class="gform_hidden" name="gform_submit" value="1">
            
            <input type="hidden" class="gform_hidden" name="gform_unique_id" value="">
            <input type="hidden" class="gform_hidden" name="state_1" value="WyJbXSIsImJlZTdjMDJkMjE5OGM3NmUyZDI2OTgxODUxYTg5NmIwIl0=">
            <input type="hidden" class="gform_hidden" name="gform_target_page_number_1" id="gform_target_page_number_1" value="0">
            <input type="hidden" class="gform_hidden" name="gform_source_page_number_1" id="gform_source_page_number_1" value="1">
            <input type="hidden" name="gform_field_values" value="">
       

</form>
</div><script type="text/javascript"> jQuery(document).bind('gform_post_render', function(event, formId, currentPage){if(formId == 1) {if(!/(android)/i.test(navigator.userAgent)){jQuery('#input_1_2').mask('(999) 999-9999').bind('keypress', function(e){if(e.which == 13){jQuery(this).blur();} } );}} } );jQuery(document).bind('gform_post_conditional_logic', function(event, formId, fields, isInit){} );</script><script type="text/javascript"> jQuery(document).ready(function(){jQuery(document).trigger('gform_post_render', [1, 1]) } ); </script>


</div>
</br></br>
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

