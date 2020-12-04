$( document ).ready(function() {
function closeOpenNav() {
 var divs=document.getElementById("main-row").children;
  if(divs[0].style.marginLeft == "-22vw"){
      divs[0].style.marginLeft = "0";
      divs[1].style.width = "80vw";
      document.getElementById("map").style.width = "80vw";
      document.getElementById("closebtn").innerHTML="<";
  }else{
      divs[0].style.marginLeft = "-22vw";
      divs[1].style.width = "96vw";
      document.getElementById("map").style.width = "96vw";
      document.getElementById("closebtn").innerHTML=">";
  }
} 
});
