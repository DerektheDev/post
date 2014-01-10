var img;
var formData;

$(function () {
  // file upload drag and drop


  $(document).bind('dragover', function (e) {
    e.preventDefault();
  });

  $('#dropzone').hover(
    function(){ $(this).data('hover',1); },
    function(){ $(this).data('hover',0); }
  )


  $(document).bind('drop', function(event) {

    event.preventDefault();

    var file = event.originalEvent.dataTransfer.files[0];
    

    if($("#dropzone").data('hover') == 1) {
      var form = $('#dropzone-form');
      var formData = new FormData(form);
      formData.append('upload', file);

      // console.log(formData);

      // $.post('/resources', {
      //   upload: formData
      // })
      // $('#dropzone-form').submit();
    } else {
      alert('did not drop on dropzone');
    }
  })



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

});
