var tmp = $.fn.popover.Constructor.prototype.show;
$.fn.popover.Constructor.prototype.show = function () {
  tmp.call(this);
  if (this.options.callback) {
    this.options.callback();
  }
}

var img;

$(function () {

  $('#dropzone').fileupload({
    dropZone: $(this),
    url: '/uploads',
    dataType: 'json',
    autoUpload: true,
    acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
    maxFileSize: 5000000, // 5 MB
    // Enable image resizing, except for Android and Opera,
    // which actually support image resizing, but fail to
    // send Blob objects via XHR requests:
    disableImageResize: /Android(?!.*Chrome)|Opera/
        .test(window.navigator.userAgent),
    previewMaxWidth: 100,
    previewMaxHeight: 100,
    previewCrop: true
  });

  $(document).bind('drop dragover', function (e) {
    e.preventDefault();
  });

  $('#image-assets li').popover({
    trigger: 'hover',
    placement: 'right',
    content: function(){
      img = "<img src='";
      img += $(this).find('a').attr('data-thumb');
      img += "' />";
      return img;
    },
    callback: function(e){
      $('.popover .popover-content').html(img);
    }
  })

  $('.fancybox').fancybox({
    openEffect: 'elastic',
    title: function(){
      rm_link = "<a href='/compiler/delete_asset?pcid=";
      rm_link += $(this).attr('paperclip-id');
      rm_link += "'>Delete Asset</a>";
      return rm_link;
    }
  });
  $('.fancybox-ajax').fancybox({
         type: 'iframe',
   openEffect: 'elastic'
  });

  $('.danger-hover').hover(
    function(){ $(this).addClass('btn-danger') },
    function(){ $(this).removeClass('btn-danger') }
  )



});