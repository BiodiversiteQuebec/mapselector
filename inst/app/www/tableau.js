$( document ).ready(function() {
$('#closebtn').on('click',function(){
  divs=$("#main-row").children();
  if(divs[0].style('margin-left') == "22vw"){
    divs[0].style('margin-left',0)
    divs[0].style('width',"80vw")
    $("#map").width("80vw");
    $("#closebtn").html('<')
  }else{
    divs[0].style('margin-left',"-22vw")
    divs[0].style('width',"96vw")
    $("#map").width("80vw");
    $("#closebtn").html('>')
  }
})
});
