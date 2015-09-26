$(function()
{
  console.log('Im here');
  $(".vote_btn").click(function(){
    console.log('Im here in func');
    $(".item_score").removeClass("hide");

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
