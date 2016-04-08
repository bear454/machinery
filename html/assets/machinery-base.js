function highlightCurrentScope() {
  $(".scope-navigation a").removeClass("active");
  current = $('.over-the-top:last');
  if(current.length == 0) {
    current = $('.scope_logo_big:first');
  }
  $(".scope-navigation a[href='#" + current.attr("id") + "']").addClass("active");
}

function setCurrentScopeState(anchor) {
  var header_height =  $("#nav-bar").height() + 20;
  var pos = anchor.offset();
  var top_pos = $(this).scrollTop() + header_height;
  if(top_pos >= pos.top) {
    anchor.addClass("over-the-top");
  } else {
    anchor.removeClass("over-the-top");
  }
}

$(document).ready(function () {
  $(".dismiss").click(function(){
    $(this).closest(".scope").hide();
  });

  $(".btn-reset").click(function(){
    $("#filter").val("").change();
  });

  $(".machinery-dropdown").click(function(){
    $(".description-selector-content").toggle();
    $(".description-selector-overlay").toggle();
    if($(".description-selector-overlay").is(':visible')) {
      $(".machinery-dropdown").not(this).attr('disabled', 'disabled');
      $(".close-comparison").attr('disabled', 'disabled');
    }else{
      if (window.location.href.indexOf("/compare/") > -1) {
        $(".machinery-dropdown").not(this).removeAttr('disabled');
        $(".close-comparison").removeAttr('disabled');
      }
    }
    if($(this).hasClass('selects')){
      $(".compare-description").hide();
      $(".show-description").show();
      $(".dropdown-header-action-show").show();
      $(".dropdown-header-action-compare").hide();
    }
    if($(this).hasClass('compares')){
      $(".compare-description").show();
      $(".show-description").hide();
      $(".dropdown-header-action-compare").show();
      $(".dropdown-header-action-show").hide();
    }
  });

  $(".description-selector-overlay").click(function(){
    $(".machinery-dropdown:enabled").trigger('click');
  });
})
