var img;

$(function () {
  // file upload drag and drop
  $('#dropzone').bind({
    mouseenter: function (event){
      // $(this).data('hover',1);
    },
    mouseleave: function (event){
      // $(this).data('hover',0);
      $(this).removeClass('alert-success', 250);
    },
    dragenter: function (event){
      $(this).addClass('alert-success', 250);
    },
    dragleave: function (event){
      $(this).removeClass('alert-success', 250);
    },
    drop: function (event){
      $(this).removeClass('alert-success', 250);


      var file = event.originalEvent.dataTransfer.files[0];

      var form = $('#dropzone-form');
      var formData = new FormData(form);
      formData.append('upload', file);

      // $.post('/resources', {
      //   upload: formData
      // })
      // $('#dropzone-form').submit();

    }
  });

  // Prevent DnD to any other part of the window
  // from taking any action
  $(document).bind('drop dragover', function(event) {
    event.preventDefault();
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
