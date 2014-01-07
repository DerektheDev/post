var img;

$(function () {
  // file upload drag and drop
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

  // image resource preview
  $('#image-resources li').popover({
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

  // load selected resource in view
  $('.resources input[type=radio]').click(function(){
    $(this).closest('form').submit();
  })

  // retrieve screenshot for a link
  // $('#compiled-browser-preview').on('click', 'a', function(e){
  //   alert('klik');
  //   e.preventDefault();
  // });

});
