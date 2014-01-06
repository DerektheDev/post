// extend popover and tooltip with callback functions
var tmp = $.fn.popover.Constructor.prototype.show;
$.fn.popover.Constructor.prototype.show = function () {
  tmp.call(this);
  if (this.options.callback) {
    this.options.callback();
  }
}
// var tmp = $.fn.tooltip.Constructor.prototype.show;
// $.fn.tooltip.Constructor.prototype.show = function () {
//   tmp.call(this);
//   if (this.options.callback) {
//     this.options.callback();
//   }
// }

$(function(){
  $('.fancybox').fancybox({
    openEffect: 'elastic'//,
    // title: function(){
    //   rm_link = "<a href='/previews/delete_asset?pcid=";
    //   rm_link += $(this).attr('paperclip-id');
    //   rm_link += "'>Delete Asset</a>";
    //   return rm_link;
    // }
  });
  $('.fancybox-ajax').fancybox({
         type: 'iframe',
   openEffect: 'elastic'
  });

  // hovering over these will turn them red
  $('.danger-hover').hover(
    function(){ $(this).addClass('btn-danger') },
    function(){ $(this).removeClass('btn-danger') }
  )
})