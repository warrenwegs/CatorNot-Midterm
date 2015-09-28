$(function()
{
  $("#item1_vote").click(function(){
    $(".vote_item1").removeClass("hide");

    setTimeout(function(){ }, 500);

  });

  $("#item2_vote").click(function(){
    $(".vote_item2").removeClass("hide");

    setTimeout(function(){ }, 500);

  });

  $("[data-image-target]")
  // .attr('placeholder', 'Image URL')
  .on("change", function(event)
  {
    var el = $(this);
    var targetId = el.data("image-target");
    var targetElement = $("#"+targetId); // "image1" -> $("#image1")
    var imgSrc = el.val();         // text value of input field that has been 'changed'
    targetElement.attr("src", imgSrc);
  });
});
