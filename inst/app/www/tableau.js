(function($) {
$(document).ready(function(){
$('#closebtn').on('click',function(){
  divs=$("#main-row").children();
  if($(divs[0]).css('margin-left') == "-22vw"){
    $(divs[0]).css('margin-left',0);
    $(divs[0]).css('width',"80vw");
    $("#map").width("80vw");
    $("#closebtn").html('<');
  }else{
    $(divs[0]).css('margin-left',"-22vw");
    $(divs[0]).css('width',"96vw");
    $("#map").width("80vw");
    $("#closebtn").html('>');
  }
});
});
})(jQuery);